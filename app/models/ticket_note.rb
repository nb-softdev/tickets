class TicketNote < ActiveRecord::Base
  belongs_to :user
  belongs_to :ticket
  
  validates :notes, :presence => true
  
  include SearchHandler
  
end
