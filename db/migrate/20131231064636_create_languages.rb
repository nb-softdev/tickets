class CreateLanguages < ActiveRecord::Migration
  def change
    create_table :languages do |t|
      t.string :name
      t.string :code
      t.text :content
      t.boolean :is_active, :default => true
      t.boolean :is_default, :default => false
      t.timestamps
    end
  end
end
