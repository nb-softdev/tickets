class User < ActiveRecord::Base
  SUPER_ADMIN = "SuperAdmin"
  COMPANY_ADMIN = "CompanyAdmin"
  USER = "User"
  STAFF = "Staff"

  acts_as_taggable
  
  acts_as_taggable_on

  acts_as_authentic do |c|
    c.validates_uniqueness_of_email_field_options :if => lambda { false }
    #c.validate_email_field = false
    #c.login_field = 'email'
  end
  
  include SearchHandler


  attr_writer :password_required

  validates :email, :presence => true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  
  validates_uniqueness_of :email, :if => :in_a_company?
  
  validates :term, :presence => true  
  
  validates_presence_of :password, :if => :password_required?

  has_one :user_role, :dependent => :destroy
  has_one :role, :through => :user_role
  
  has_many :tickets, :dependent => :destroy
  has_many :ticket_replies, dependent: :destroy
  has_many :ticket_notes, dependent: :destroy
  has_many :tags
  belongs_to :company
  
  scope :all_users, joins(:role).where(:roles => { :role_type => USER })
  
  scope :all_staffs, joins(:role).where(:roles => { :role_type => STAFF })
  
  scope :all_users_and_staffs, joins(:role).where(:roles => { :role_type => [USER, STAFF] })
  
  scope :all_users_and_staffs_and_company_admins, joins(:role).where(:roles => { :role_type => [USER, STAFF, COMPANY_ADMIN] })
  
  def in_a_company?
    user_in_company_exist = User.find_by_email(email)
    if user_in_company_exist
      company_id == user_in_company_exist.company_id
    end  
  end
  
  def password_required?
    @password_required
  end

  mount_uploader :image, ImageUploader

  def has_role?(role)
    self.user_role.role.role_type == role
  end

  def is_admin?
    has_role?(SUPER_ADMIN)
  end

  def is_user?
   has_role?(USER)
  end
  
  def is_staff?
   has_role?(STAFF)
  end  
  
  def is_company_admin?
    has_role?(COMPANY_ADMIN)
  end
  
  def is_company_admin_or_staff?
    has_role?(COMPANY_ADMIN) or has_role?(STAFF) 
  end    

  def name(shorten=true)
    if self.first_name.present? && self.last_name.present?
      [first_name, last_name].join(" ")
    else
      self.email
    end
  end


end
