class EmailTemplate < ActiveRecord::Base
  validates :subject, :presence => true
  include SearchHandler
end
