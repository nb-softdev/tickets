class ChangeTicketReplyTableColumnName < ActiveRecord::Migration
  def change
    rename_column :ticket_replies, :user_id_id, :user_id
  end
end
