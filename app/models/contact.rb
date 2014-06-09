class Contact < ActiveRecord::Base
  validates :name, :email, :presence => true
  include SearchHandler
end
