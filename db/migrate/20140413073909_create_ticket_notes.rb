class CreateTicketNotes < ActiveRecord::Migration
  def change
    create_table :ticket_notes do |t|
      t.references :ticket
      t.references :user
      t.text       :notes
      t.timestamps
    end
  end
end