class TicketReply < ActiveRecord::Base
  belongs_to :user
  belongs_to :ticket
  
  validates :description, :presence => true
  
  mount_uploader :attached_file, TicketReplyUploader
  
  scope :staff, -> { where(:user_type => "Staff") }
  scope :user, -> { where(:user_type => "User") }
end
