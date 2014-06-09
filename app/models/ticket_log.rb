class TicketLog < ActiveRecord::Base
  belongs_to :ticket
  validates :logs, :presence => true
  include SearchHandler
  
  def self.create_ticket_log(ticket, current_user)
    self.create(:ticket => ticket, :logs => "#{current_user.name} has <b>Created Ticket</b> at #{ticket.created_at.to_s(:pretty_view)}")
  end  
  
  def self.create_reply_post_log(ticket, ticket_reply, current_user)
    self.create(:ticket => ticket, :logs => "#{current_user.name} has <b>Posted Reply</b> #{ticket_reply.description} at #{ticket_reply.created_at.to_s(:pretty_view)}")
  end
  
  def self.update_reply_post_log(ticket_reply, current_user)
    self.create(:ticket => ticket_reply.ticket, :logs => "#{current_user.name} has <b>Updated Reply</b> #{ticket_reply.description} at #{ticket_reply.updated_at.to_s(:pretty_view)}")
  end  
  
  def self.create_priority_log(ticket, before_priority, after_priority, current_user)
    self.create(:ticket => ticket, :logs => "#{current_user.name} has changed <b>Priority</b> from #{before_priority} to #{after_priority} at #{ticket.updated_at.to_s(:pretty_view)}")
  end
  
  def self.create_status_log(ticket, before_status, after_status, current_user)
    self.create(:ticket => ticket, :logs => "#{current_user.name} has changed <b>Status</b> from #{before_status} to #{after_status} at #{ticket.updated_at.to_s(:pretty_view)}")
  end
  
  def self.create_assigned_log(ticket, assigned_to, after_status, current_user)
    self.create(:ticket => ticket, :logs => "#{current_user.name} has <b>Assigned</b> ticket #{assigned_to} at #{ticket.updated_at.to_s(:pretty_view)}")
  end
  
  def self.create_tag_log(ticket, tag, current_user)
    self.create(:ticket => ticket, :logs => "#{current_user.name} has <b>Added Tag</b> #{tag.name} at #{Time.now.to_s(:pretty_view)}")
  end          
  
  def self.create_note_log(ticket, ticket_note, current_user)
    self.create(:ticket => ticket, :logs => "#{current_user.name} has created <b>Note</b> #{ticket_note.notes} at #{ticket_note.created_at.to_s(:pretty_view)}")
  end
  
  def self.update_note_log(ticket, ticket_note, current_user)
    self.create(:ticket => ticket, :logs => "#{current_user.name} has updated <b>Note</b> #{ticket_note.notes} at #{ticket_note.updated_at.to_s(:pretty_view)}")
  end        
    
end
