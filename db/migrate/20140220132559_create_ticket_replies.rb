class CreateTicketReplies < ActiveRecord::Migration
  def change
    create_table :ticket_replies do |t|
      t.references :ticket
      t.references :user
      t.string     :user_type
      t.text       :description
      t.string     :attached_file
      t.timestamps
    end
  end
end
