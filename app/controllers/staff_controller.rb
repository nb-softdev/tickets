class StaffController < ApplicationController
  before_action :require_user
  before_action :set_ticket, only: [:ticket_reply, :ticket_actions]
  helper_method :sort_column, :sort_direction
  before_action :destroy_all_selected, :apply_tags, only: [:tickets]
  skip_before_filter :verify_authenticity_token
  
  def tickets
    session[:search_params] = params[:ticket] ? params[:ticket] : nil
    
    #tags
    @tags = current_user.tags

    respond_to do |format|
      if params[:ticket_actions_submit]
        save_ticket_actions
        format.js { render action: 'ticket_actions' }
      else
        if current_user.is_company_admin_or_staff?
          tickets = current_company.tickets.active
        else
          tickets = current_user.tickets.active
        end
        
        tickets = tickets.tagged_with(params[:tag]) if params[:tag]
        tickets = tickets.where(:staff => current_user) if params[:my_ticket]
        
        @tickets = tickets.includes(:staff).search(session[:search_params])
            .order(sort_column + " " + sort_direction)
            .paginate(:per_page => PER_PAGE, :page => params[:page])

        @params_arr = { :subject => { "type" => 'text' } }
        @o_single = Ticket.new
        format.js { render action: 'tickets' }
        format.html { }
      end
    end
  end

  def ticket_reply
    @ticket_replies = @ticket.ticket_replies.includes(:user).order(id: :desc)
    @ticket_notes = @ticket.ticket_notes.includes(:user).order(id: :desc)
    @ticket_reply = TicketReply.new
  end

  def ticket_reply_create
    @ticket = Ticket.find(params[:ticket_reply][:ticket_id])
    @ticket_replies = @ticket.ticket_replies.includes(:user).order(id: :desc)
    @ticket_reply = TicketReply.new(ticket_reply_params)
    respond_to do |format|
      if @ticket_reply.save
        flash[:success_reply] = "Successfully posted."
        
        #ticket log
        TicketLog.create_reply_post_log(@ticket, @ticket_reply, current_user)
        
        if params[:reply_close]
          @ticket.status_id = CLOSE
          @ticket.save
          flash[:success_reply] = "Successfully posted and ticket has been closed."
        end
      else
        flash[:notice_reply] = "Can't be blank."
      end
      format.js
    end
  end

  def ticket_actions
    if request.post?
      ticket = Ticket.new(ticket_params)
      ticket.save
      @save_record = true
    else
      @save_record = false
    end
  end

  private
  
  def save_ticket_actions
    @ticket = Ticket.find(params[:ticket][:id])
    @ticket.update(ticket_params)
    #create tags
    create_tags
    session[:search_params] = nil
    @save_record = true     
  end  

  def destroy_all_selected
    if params[:rec] and params[:tag_or_destroy] == "destroy_all"
      id_arrs = params[:rec].collect { |k, v| k }
      Ticket.find(id_arrs).map(&:destroy)
      flash[:notice] = t("general.successfully_destroyed")
    end
  end

  def create_tags
    @ticket_before =  Ticket.find(params[:ticket][:id])
    if params[:ticket][:priority_id] and @ticket_before.priority_id != @ticket.priority_id
      before_priority = ticket_priority_hash[@ticket_before.priority_id.to_s]
      after_priority = ticket_priority_hash[@ticket.priority_id.to_s]
      #ticket log
      TicketLog.create_priority_log(@ticket, before_priority, after_priority, current_user)
    end

    if params[:ticket][:status_id] and @ticket_before.status_id != @ticket.status_id
      before_status = ticket_status_hash[@ticket_before.status_id.to_s]
      after_status = ticket_status_hash[@ticket.status_id.to_s]
      #ticket log
      TicketLog.create_status_log(@ticket, before_status, after_status, current_user)
    end

    if @ticket_before.staff_id != @ticket.staff_id
      before_staff = @ticket_before.staff.try(:name)
      after_staff = @ticket.staff.try(:name)
      if @ticket_before.staff and @ticket.staff
        assigned_to = "from #{before_staff} to #{after_staff}"
      elsif @ticket_before.staff and !@ticket.staff
        assigned_to = "from #{before_staff} to no one"
      elsif !@ticket_before.staff and @ticket.staff
        assigned_to = "to #{after_staff}"
      else
        assigned_to = ""
      end
      #ticket log
      TicketLog.create_assigned_log(@ticket, assigned_to, after_status, current_user)
    end
  end

  def apply_tags
    if params[:tag_check] and params[:rec] and params[:tag_or_destroy] == "apply_labels"
      ticket_id_arrs = params[:rec].collect { |k, v| k }

      ticket_id_arrs.each do |p|
        ticket = Ticket.find(p)
        tags = Tag.all.collect {|r| r.name}
        ticket.tag_list.remove(tags)
        ticket.save
      end

      tag_id_arrs = params[:tag_check].collect { |k, v| k }

      tag_id_arrs.each do |k|

        tag = Tag.find(k)
        ticket_id_arrs.each do |p|
          ticket = Ticket.find(p)
          ticket.tag_list.add(tag.name)
          ticket.save
          #ticket log
          TicketLog.create_tag_log(ticket, tag, current_user)
        end
      end
    end
  end

  def ticket_reply_params
    params.require(:ticket_reply).permit!
  end

  def ticket_params
    params.require(:ticket).permit!
  end

  def set_ticket
    @ticket = current_company.tickets.find_by_id(params[:id])
    unless @ticket
      redirect_to company_front_path(current_company.sub_domain)
    end
  end

  def sort_column
    Ticket.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
end
