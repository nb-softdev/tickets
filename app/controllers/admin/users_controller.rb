class Admin::UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :destroy_all_selected, only: [:index]
  helper_method :sort_column, :sort_direction
  before_action :require_admin_or_company_admin
  
  layout "admin"

  # GET /users
  # GET /users.json
  def index
    session[:search_params] = params[:user] ? params[:user] : nil

    session[:set_pager_number] = params[:set_pager_number] if params[:set_pager_number]

    if session[:set_pager_number].nil?
      session[:set_pager_number] = 10
    end

    if current_company
      users = @current_company.users.all_users_and_staffs
    else
      users = User.all_users_and_staffs_and_company_admins
    end  

    @o_all = users.
                  user_search(session[:search_params]).
                  order(sort_column + " " + sort_direction).
                  paginate(:per_page => session[:set_pager_number], :page => params[:page])

    @params_arr = { :first_name => { "type" => 'text' }, :email => { "type" => 'text' } }

    @o_single = controller_name.classify.constantize.new
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @o_single = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /user_sessions
  # POST /user_sessions.xml
  def create
    @o_single = User.new(user_params)
    respond_to do |format|
      if @o_single.save
        @o_single.role = Role.find(params[:role_id])
        format.html { redirect_to admin_users_url, notice: t("general.successfully_created") }
        format.json { head :no_content }
      else
        format.html { render action: 'new' }
        format.json { render json: @o_single.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @o_single.update(user_params)
        @o_single.role = Role.find(params[:role_id])
        format.html { redirect_to admin_users_url, notice: t("general.successfully_updated") }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @o_single.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @o_single.destroy
    respond_to do |format|
      format.html { redirect_to admin_users_url, notice: t("general.successfully_destroyed") }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @o_single = User.find(params[:id])
    end

    def destroy_all_selected
      if params[:rec]
        id_arrs = params[:rec].collect { |k, v| k }
        User.find(id_arrs).map(&:destroy)
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit!
    end

    def set_header_menu_active
      @users = "active"
    end

    def sort_column
      User.column_names.include?(params[:sort]) ? params[:sort] : "id"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end

end
