class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :default_name
      t.string :default_label
      t.string :default_value
      t.boolean :is_active, :default => true
      t.timestamps
    end
  end
end
