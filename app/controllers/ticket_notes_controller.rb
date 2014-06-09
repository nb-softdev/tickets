class TicketNotesController < ApplicationController
  before_action :set_ticket_note, only: [:show, :edit, :update, :destroy]
  before_action :set_ticket, only: [:new, :create, :edit, :update, :destroy]
  before_action :destroy_all_selected, only: [:index]
  helper_method :sort_column, :sort_direction
  before_action :require_staff_or_company_admin
  
  # GET /ticket_ticket_notes
  # GET /ticket_ticket_notes.json
  def index
    session[:search_params] = params[:ticket_note] ? params[:ticket_note] : nil

    session[:set_pager_number] = params[:set_pager_number] if params[:set_pager_number]

    if session[:set_pager_number].nil?
      session[:set_pager_number] = PER_PAGE
    end

    @o_all = TicketNote.
                  search(session[:search_params]).
                  order(sort_column + " " + sort_direction).
                  paginate(:per_page => session[:set_pager_number], :page => params[:page])

    @params_arr = { :ticket_ticket_notes => { "type" => 'text' } }

    @ticket_note = controller_name.classify.constantize.new
  end

  # GET /ticket_ticket_notes/1
  # GET /ticket_ticket_notes/1.json
  def show
  end

  # GET /ticket_ticket_notes/new
  def new
    @ticket_note = TicketNote.new
  end

  # GET /ticket_ticket_notes/1/edit
  def edit
  end

  # POST /ticket_ticket_notes
  # POST /ticket_note_sessions
  # POST /ticket_note_sessions.xml
  def create
    @ticket_note = TicketNote.new(ticket_note_params)
    respond_to do |format|
      if @ticket_note.save
        #ticket log
        TicketLog.create_note_log(@ticket, @ticket_note, current_user)
        @ticket_notes = @ticket.ticket_notes.includes(:user).order(id: :desc)
        format.js { render action: 'create' }
      else
        format.js { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /ticket_ticket_notes/1
  # PATCH/PUT /ticket_ticket_notes/1.json
  def update
    respond_to do |format|
      if @ticket_note.update(ticket_note_params)
        #ticket log
        TicketLog.update_note_log(@ticket, @ticket_note, current_user)        
        @ticket_notes = @ticket.ticket_notes.includes(:user).order(id: :desc)
        format.js { render action: 'update' }
      else
        format.js { render action: 'edit' }
      end
    end
  end

  # DELETE /ticket_ticket_notes/1
  # DELETE /ticket_ticket_notes/1.json
  def destroy
    @ticket_note.destroy
    respond_to do |format|
      format.html { redirect_to ticket_ticket_notes_url(@current_company.sub_domain), notice: t("general.successfully_destroyed") }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ticket_note
      @ticket_note = TicketNote.find(params[:id])
    end
    
    def set_ticket
      @ticket = Ticket.find(session[:ticket_id]) 
    end  

    def destroy_all_selected
      if params[:rec]
        id_arrs = params[:rec].collect { |k, v| k }
        TicketNote.find(id_arrs).map(&:destroy)
        flash[:notice] = t("general.successfully_destroyed")
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ticket_note_params
      params.require(:ticket_note).permit!
    end

    def set_header_menu_active
      @ticket_ticket_notes = "active"
    end

    def sort_column
      TicketNote.column_names.include?(params[:sort]) ? params[:sort] : "id"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end

end
