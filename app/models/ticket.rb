class Ticket < ActiveRecord::Base
  
  after_create :set_create_logs
 
  has_many :ticket_replies, dependent: :destroy
  has_many :ticket_notes, dependent: :destroy
  has_many :ticket_logs, dependent: :destroy
  belongs_to :user
  belongs_to :company
  
  belongs_to :staff, :class_name => 'User', :foreign_key => :staff_id
  
  acts_as_taggable
  
  acts_as_taggable_on
  
  mount_uploader :attached_file, TicketUploader
  
  include SearchHandler
  
  validates :subject, :description, :priority_id, :presence => true
  
  scope :active, -> { where(:is_active => true) }
  scope :open, -> { where(:status_id => 1) }
  
  scope :open_and_on_hold, -> { where(:status_id => [1, 2]) }
  
  scope :close, -> { where(:status_id => 2) }
  
  #ticket log
  def set_create_logs
    TicketLog.create(:ticket => self, :logs => "#{self.user.name} has <b>Created Ticket</b> at #{self.created_at.to_s(:pretty_view)}")
  end
  
  def is_last_reply_by_staff?(current_user_id)
     ticket_reply = self.ticket_replies.order("id desc").first
     if ticket_reply.present?
       unless ticket_reply.user_id == current_user_id
         return true
       else
         return false  
       end
     else
       return false  
     end
  end
  
  def last_reply_user
     ticket_reply = self.ticket_replies.order("id desc").first
     ticket_reply.user.try(:name) if ticket_reply.present?    
  end
  
end
