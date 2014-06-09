class CreateFooterPages < ActiveRecord::Migration
  def change
    create_table :footer_pages do |t|
      t.string :name
      t.string :page_route
      t.text :content
      t.boolean :is_footer, :default => true
      t.timestamps
    end
  end
end
