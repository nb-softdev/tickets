# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# Create a admin user
puts '==================================================================='
puts 'Load super admin'
puts '==================================================================='
@admin = User.new(:last_name => 'Admin', :first_name => 'Admin', :password => 'admin', :password_confirmation => 'admin', :email => 'admin@supportengine.com', :is_active => 1, :term => true)
@admin.save(:validate => false)

puts '==================================================================='
puts 'Load roles'
puts '==================================================================='
# Create a role type for users
@admin_role = Role.create(:role_type => "SuperAdmin")
@company_admin_role = Role.create(:role_type => "CompanyAdmin")
@staff_role = Role.create(:role_type => "Staff")
@user_role = Role.create(:role_type => "User")

puts '==================================================================='
puts 'Load user roles'
puts '==================================================================='
# Create a role type for users
@admin.role = @admin_role



puts 'load footer pages'

help = FooterPage.create(:name => 'Help',
                        :page_route => 'help',
                        :content => "Help",
                        :is_footer => true
                        )

privacy = FooterPage.create(:name => 'Privacy policy',
                        :page_route => 'privacy',
                        :content => "privacy policy",
                        :is_footer => true
                        )

aboutus = FooterPage.create(:name => 'About us',
                        :page_route => 'about-us',
                        :content => "About us",
                        :is_footer => true
                        )

disclaimer = FooterPage.create(:name => 'Legal Disclaimer',
                        :page_route => 'legal-disclaimer',
                        :content => "Legal disclaimer",
                        :is_footer => true
                        )

puts 'create default languages'

english = Language.create(:name => "English",
                          :code => "en",
                          :is_default => true
                          )
                          
puts 'create default email templates'

                          
email_template = EmailTemplate.create(:subject => "Registration",
                          :content => "Registration",
                          :email_type => "registration_email")                         
                          
email_template = EmailTemplate.create(:subject => "Forgot Password",
                          :content => "Forgot Password",
                          :email_type => "forgot_password")   
