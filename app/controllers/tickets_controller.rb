class TicketsController < ApplicationController

  skip_before_filter :verify_authenticity_token, only: [:update_ticket]
    
  before_action :require_company, only: [:new]
  
  OPEN = 1
  ON_HOLD = 2
  CLOSE = 3
  USER = "User"

  # GET /tickets/1
  # GET /tickets/1.json
  def show
    @ticket = Ticket.where(:ticket_secret => params[:id].to_s).first
    if @ticket.present?
      @ticket_replies = @ticket.ticket_replies.order(id: :desc)
      @ticket_reply = TicketReply.new
    end
  end

  # GET /tickets/new
  def new
    @ticket = Ticket.new
  end

  # POST /tickets
  # POST /tickets.json
  def create
    unless current_user.present?
      @is_user_login = false
      # check user exsist
      if @user = User.find_by_email_and_company_id(params[:user][:email], params[:ticket][:company_id])
        @user_exist = true
        params[:ticket][:user_id] = @user.id
        @user_session = UserSession.new(@user, true)            
        if @user_session.save
          session[:user_id] = @user.id
          session[:user_role] = @user.role.role_type     
        end        
      else
        @user_exist = false
        if params[:user][:email].present? 
          params[:user][:password] = params[:user][:password_confirmation] = SecureRandom.hex(8)
          params[:user][:registration_key] = SecureRandom.hex(25)
          params[:user][:term] = params[:user][:is_active] = true
          params[:user][:company_id] = params[:ticket][:company_id]  
          params[:user][:company_id] = params[:ticket][:company_id]
          
          @user = User.new(user_params)
          
          #user save
          if @user.save
            #create user role  
            @user.role = Role.find_by(:role_type => USER)
            
            #user session create            
            @user_session = UserSession.new(@user, true)            
            if @user_session.save
              session[:user_id] = @user.id
              session[:user_role] = @user.role.role_type     
            end
          else
            @ticket = Ticket.new
            render action: 'new'
            return
          end
        end        
      end
      
    else
      @user = current_user
      @user_exist = true
      @is_user_login = true
    end
    
    @ticket = Ticket.new(ticket_params)
    
    respond_to do |format|
      if @ticket.save
        @ticket.ticket_secret = SecureRandom.hex(5).to_s + @ticket.id.to_s
        @ticket.user_id = @user.id
        @ticket.save
        
        #ticket log
        TicketLog.create_ticket_log(@ticket, @user)
        
        @ticket_notes = @ticket.ticket_notes.includes(:user).order(id: :desc)        
        
        #ticket reply
        TicketReply.create(:ticket_id => @ticket.id, :user_id => @user.id, :user_type => USER, :description => @ticket.description)
        
        if @user_exist
          # send mail to user with ticket link
          opts = { 
            :ticket => @ticket,
            :ticket_status => ticket_status_hash[@ticket.status_id.to_s],
            :ticket_priority => ticket_priority_hash[@ticket.priority_id.to_s],
            :email => @user.email            
          }
          TicketMailer.new_ticket_email_with_user(@user.email, @current_company.sub_domain, opts).deliver
        else
          # send mail to user with ticket link
          opts = { 
            :ticket => @ticket,
            :ticket_status => ticket_status_hash[@ticket.status_id.to_s],
            :ticket_priority => ticket_priority_hash[@ticket.priority_id.to_s],           
            :email => @user.email, 
            :password => params[:user][:password]            
          }
          TicketMailer.new_ticket_email_without_user(@user.email, @current_company.sub_domain, opts).deliver            
        end        
        unless current_user.present?
          format.html { redirect_to login_url, notice: 'Ticket was successfully created.' }
        else
          format.html { redirect_to staff_tickets_path, notice: 'Ticket was successfully created.' }
        end
      else
        unless @is_user_login
          @user_session = UserSession.find
          if @user_session
            @user_session.destroy
          end
          session[:user_role] = session[:user_id] = nil
        end
                  
        format.html { render action: 'new' }
      end
    end
  end


  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def ticket_params
      params.require(:ticket).permit!
    end
    
    def user_params
      params.require(:user).permit!
    end

end
