class UserMailer < ActionMailer::Base
  
  default :from => "'SupportEngine' <noreply@supportengine.com>"
  
  # new user registration 
  def registration_confirmation(email, opts)
    @username = opts[:username]
    @registration_key = opts[:registration_key]
    @email = opts[:email]
    @password = opts[:password]
    @application = t("general.app_title")
    mail(:to => "#{email}", :subject => t("mail.registration_confirmation.confirm_your_email_to_start"))
  end
  
  # new company registration 
  def company_registration_confirmation(email, opts)
    @company = opts[:company]
    mail(:to => "#{email}", :subject => "#{@company.name} has sent request to join SupportEngine")
  end  

  # forgot password
  def forgot_password_confirmation(email, opts)
    @username = opts[:username]
    @new_pass = opts[:new_pass]
    @application = t("general.app_title")
    mail(:to => "#{email}", :subject => t("general.reset_password"), :content_type => "text/html")
  end
end
