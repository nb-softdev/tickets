class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :name
      t.text :body
      t.integer :rating
      t.boolean :published

      t.timestamps
    end
  end
end
