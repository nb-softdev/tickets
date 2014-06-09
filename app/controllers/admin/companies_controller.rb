class Admin::CompaniesController < ApplicationController
  before_action :set_company, only: [:show, :edit, :update, :destroy]
  before_action :destroy_all_selected, only: [:index]
  helper_method :sort_column, :sort_direction
  before_action :require_admin_or_company_admin

  layout "admin"

  # GET /companies
  # GET /companies.json
  def index
    session[:search_params] = params[:company] ? params[:company] : nil

    session[:set_pager_number] = params[:set_pager_number] if params[:set_pager_number]

    if session[:set_pager_number].nil?
      session[:set_pager_number] = 10
    end

    @o_all = Company.
                  user_search(session[:search_params]).
                  order(sort_column + " " + sort_direction).
                  paginate(:per_page => session[:set_pager_number], :page => params[:page])

    @params_arr = { :name => { "type" => 'text' }, :url => { "type" => 'text' } }

    @o_single = controller_name.classify.constantize.new
  end

  # GET /companies/1
  # GET /companies/1.json
  def show
  end

  # GET /companies/new
  def new
    @o_single = Company.new
  end

  # GET /companies/1/edit
  def edit
  end

  # POST /companies
  # POST /company_sessions
  # POST /company_sessions.xml
  def create
    @o_single = Company.new(company_params)
    respond_to do |format|
      if @o_single.save
        format.html { redirect_to admin_companies_url, notice: t("general.successfully_created") }
        format.json { head :no_content }
      else
        format.html { render action: 'new' }
        format.json { render json: @o_single.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /companies/1
  # PATCH/PUT /companies/1.json
  def update
    respond_to do |format|
      if @o_single.update(company_params)
        format.html { redirect_to admin_companies_url, notice: t("general.successfully_updated") }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @o_single.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.json
  def destroy
    @o_single.destroy
    respond_to do |format|
      format.html { redirect_to admin_companies_url, notice: t("general.successfully_destroyed") }
      format.json { head :no_content }
    end
  end
  
  # GET /companies/users/1
  def users
    include_blank = [["Select User", ""]]
    if params[:ticket][:company_id].present?
      @company_users = include_blank + User.all_users.where(:company_id => params[:ticket][:company_id]).collect {|u| [u.name, u.id]}
    else
      @company_users = include_blank
    end
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @o_single = Company.find(params[:id])
    end

    def destroy_all_selected
      if params[:rec]
        id_arrs = params[:rec].collect { |k, v| k }
        Company.find(id_arrs).map(&:destroy)
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def company_params
      params.require(:company).permit!
    end

    def set_header_menu_active
      @companies = "active"
    end

    def sort_column
      Company.column_names.include?(params[:sort]) ? params[:sort] : "id"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end

end
