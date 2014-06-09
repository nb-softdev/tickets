class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.references :user
      t.string :name
      t.string :email
      t.text :message
      t.boolean :is_feedback, :default => false
      t.timestamps
    end
  end
end
