class Admin::ContactsController < ApplicationController
  before_action :set_contact, only: [:show, :edit, :update, :destroy]
  before_action :destroy_all_selected, only: [:index]
  helper_method :sort_column, :sort_direction
  before_action :require_admin, only: [:index, :show, :edit, :update, :destroy]

  layout "admin"
  
  # GET /contacts
  # GET /contacts.json
  def index
    session[:search_params] = params[:contact] ? params[:contact] : nil

    session[:set_pager_number] = params[:set_pager_number] if params[:set_pager_number]

    if session[:set_pager_number].nil?
      session[:set_pager_number] = PER_PAGE
    end

    @o_all = Contact.
                  search(session[:search_params]).
                  order(sort_column + " " + sort_direction).
                  paginate(:per_page => session[:set_pager_number], :page => params[:page])

    @params_arr = { :name => { "type" => 'text' }, :email => { "type" => 'text' } }

    @o_single = controller_name.classify.constantize.new
  end

  # GET /contacts/1
  # GET /contacts/1.json
  def show
  end

  # GET /contacts/new
  def new
    @o_single = Contact.new
  end

  # GET /contacts/1/edit
  def edit
  end

  # POST /contacts
  # POST /contact_sessions
  # POST /contact_sessions.xml
  def create
    @o_single = Contact.new(contact_params)
    respond_to do |format|
      if @o_single.save
        format.html { redirect_to admin_contacts_url, notice: t("general.successfully_created") }
        format.json { head :no_content }
      else
        format.html { render action: 'new' }
        format.json { render json: @o_single.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contacts/1
  # PATCH/PUT /contacts/1.json
  def update
    respond_to do |format|
      if @o_single.update(contact_params)
        format.html { redirect_to admin_contacts_url, notice: t("general.successfully_updated") }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @o_single.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.json
  def destroy
    @o_single.destroy
    respond_to do |format|
      format.html { redirect_to admin_contacts_url, notice: t("general.successfully_destroyed") }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact
      @o_single = Contact.find(params[:id])
    end

    def destroy_all_selected
      if params[:rec]
        id_arrs = params[:rec].collect { |k, v| k }
        Contact.find(id_arrs).map(&:destroy)
        flash[:notice] = t("general.successfully_destroyed")
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contact_params
      params.require(:contact).permit!
    end

    def set_header_menu_active
      @contacts = "active"
    end

    def sort_column
      Contact.column_names.include?(params[:sort]) ? params[:sort] : "id"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end

end
