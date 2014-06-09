class CreateTicketLogs < ActiveRecord::Migration
  def change
    create_table :ticket_logs do |t|
      t.references :ticket
      t.text       :logs
      t.boolean    :is_deleted, :default => false
      t.timestamps
    end
  end
end
