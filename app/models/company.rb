class Company < ActiveRecord::Base
  has_many :users
  has_many :tickets
  has_many :tags
  mount_uploader :logo, ImageUploader
  
  include SearchHandler
  
  validates :name, :email, :url, :presence => true
  
  validates :sub_domain, :presence => true, uniqueness: true
  
  def is_confirmed_and_active?
    self.is_confirmed and self.is_active
  end
end
