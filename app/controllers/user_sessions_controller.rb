class UserSessionsController < ApplicationController
  before_action :require_company, :except => [:new, :create, :destroy, :admin_login]
  
  skip_before_filter :verify_authenticity_token
  
  # GET /user_sessions
  def index
    redirect_to new_user_session_path
  end

  # GET login
  def new
    if request.path == '/admin'
      session[:current_company_id] = session[:current_sub_domain] = nil
    end
    
    if current_user
      redirect_to root_path
    else 
      if request.path == "/login" and @current_company.nil?
        redirect_to root_path
      else 
        @user_session = UserSession.new
      end  
    end
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    respond_to do |format|
      if @user_session.save
        if current_user.is_active
          session[:user_id] = current_user.id
          session[:user_role] = current_user.role.role_type
          flash[:notice] = t("general.login_successful")
          if is_admin?
            d_path = admin_companies_url
          else 
            if @current_company
              #set company in session
              session[:current_sub_domain] = current_user.company.sub_domain
              @current_company = Company.find_by(:sub_domain => session[:current_sub_domain])
              
              #redirect to appropriate location
              if is_company_admin?
                d_path = users_url(@current_company.sub_domain)
              elsif is_staff?
                d_path = staff_tickets_url(@current_company.sub_domain)
              elsif is_user? 
                d_path = new_ticket_url(@current_company.sub_domain)
              else
                d_path = root_url  
              end
            else
              reset_session_with_error
              flash[:error] = t("general.you_are_not_admin_user")
              format.html { render :action => "new" }
            end  
          end
          format.html { redirect_to d_path }
        else
          reset_session_with_error
          flash[:error] = t("general.you_are_not_active_user")
          format.html { render :action => "new" }
        end
      else
        format.html { render :action => "new" }
      end
    end
  end

  # GET logout
  def destroy
    sub_domain = @current_company ? @current_company.sub_domain : ""
    @user_session = UserSession.find
    if @user_session
      @user_session.destroy
    end
    session[:user_id] = nil
    reset_session
    flash[:notice] = t("general.logout_successful")
    redirect_to (sub_domain.present? ? company_front_path(sub_domain) : root_url)
  end

  # GET signup
  def signup
    @o_single = User.new
    if request.post?
      params[:user][:password_confirmation] = params[:user][:password]
      params[:user][:registration_key] = SecureRandom.hex(25)
      params[:user][:time_zone] = 'UTC'
      @o_single = User.new(user_params)

      respond_to do |format|
        #create user
        if @o_single.save
          #create user role
          @o_single.role = Role.find_by(:role_type => USER)
          opts = {
            :username => @o_single.email, 
            :email => @o_single.email, 
            :password => params[:user][:password], 
            :registration_key => @o_single.registration_key
          }
          UserMailer.registration_confirmation(@o_single.email, opts).deliver

          @user_session = UserSession.new(@o_single, true)            
          if @user_session.save
            session[:user_id] = @o_single.id
            session[:user_role] = @o_single.role.role_type
            notice = t("general.successfully_registered")     
          end

          format.html { redirect_to new_ticket_url(@current_company.sub_domain), notice: notice }
        else
          format.html { render action: 'signup' }
        end
      end
    end
  end

  private
  
  def reset_session_with_error
    reset_session
    @user_session = UserSession.find
    if @user_session
      @user_session.destroy
    end
    session[:user_id] = nil
    @user_session = UserSession.new(params[:user_session])
  end
      
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_session_params
      params[:user_session]
    end

    def user_params
      params.require(:user).permit!
    end
end
