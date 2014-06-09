class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.references :user
      t.string       :subject
      t.text       :description
      t.integer       :priority_id
      t.integer       :status_id
      t.string       :attached_file
      t.boolean      :is_active, :default => true
      t.timestamps
    end
  end
end
