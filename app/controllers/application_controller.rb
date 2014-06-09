class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :is_admin?, :is_user?, :is_staff?, :is_company_admin?
  before_filter :current_company, :verify_current_compnay
  before_filter :_set_current_session
	SUPER_ADMIN = "SuperAdmin"
	COMPANY_ADMIN = "CompanyAdmin"
	USER = "User"
  STAFF = "Staff"
  OPEN = 1
  ON_HOLD = 2
  CLOSE = 3
  PER_PAGE = 5
    
  private

    def current_company
      return @current_company if defined?(@current_company)
      if session[:current_sub_domain]
        @current_company = Company.find_by(:sub_domain => session[:current_sub_domain])
        session[:current_company_id] = @current_company ? @current_company.id : nil
      else
        @current_company = Company.find_by(:url => request.host)
      end
    end
    
    def verify_current_compnay
      if @current_company and params[:sub_domain]
        unless @current_company.sub_domain == params[:sub_domain]
          if current_user
            redirect_to company_front_path(@current_company.sub_domain)
          else
            @current_company = Company.find_by(:sub_domain => params[:sub_domain])
            if @current_company
              session[:current_company_id] = @current_company ? @current_company.id : nil
              session[:current_sub_domain] = @current_company ? @current_company.sub_domain : nil            
              redirect_to company_front_path(@current_company.sub_domain)
            else
              redirect_to root_path
            end    
          end    
        end 
      end
    end 

    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
	    @current_user = current_user_session && current_user_session.record
    end

    def require_user
      unless current_user
        redirect_to root_url
      end
    end
    
    def require_admin
      unless session[:user_role] == SUPER_ADMIN
        redirect_to root_url
      end
    end

    def require_company_admin
      unless session[:user_role] == COMPANY_ADMIN
        redirect_to root_url
      end
    end  
    
    def require_admin_or_company_admin
      unless session[:user_role] == COMPANY_ADMIN || session[:user_role] == SUPER_ADMIN
        redirect_to root_url
      end
    end  
    
    def require_company
      unless current_company
        redirect_to root_url
      end      
    end
    
    def require_staff
      unless session[:user_role] == STAFF
        redirect_to root_url
      end
    end    
    
    def require_staff_or_company_admin
      unless session[:user_role] == STAFF || session[:user_role] == COMPANY_ADMIN
        redirect_to root_url
      end
    end      

    def authenticate_email(email)
      user = User.where(:email => email).first
      if user
			  return user
	    end
	    return false
    end

    def authenticate_change_password(password)
        user_exists = User.exists?(password: password)
        if user_exists
		  user = User.find_by_password(password)
		  return user
	    end
	    return false
    end

	  def is_admin?
		  session[:user_role] == SUPER_ADMIN
	  end

    def is_user?
	   session[:user_role] == USER
    end
    
    def is_staff?
     session[:user_role] == STAFF
    end
    
    def is_company_admin?
     session[:user_role] == COMPANY_ADMIN
    end        

    def ticket_status_hash
      {"1" => "Open", "2" => "On Hold", "3" => "Close"}
    end
    
    def ticket_priority_hash
      {"1" => "Low", "2" => "Medium", "3" => "High", "4" => "Urgent", "5" => "Emergency", "6" => "Critical"}
    end
    
    protected
    def _set_current_session
      # Define an accessor. The session is always in the current controller
      # instance in @_request.session. So we need a way to access this in
      # our model
      accessor = instance_variable_get(:@_request)
  
      # This defines a method session in ActiveRecord::Base. If your model
      # inherits from another Base Class (when using MongoMapper or similar),
      # insert the class here.
      ActiveRecord::Base.send(:define_method, "session", proc {accessor.session})
    end    

end
