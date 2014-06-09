class AddImageToUsers < ActiveRecord::Migration
  def change
    add_column :users, :image, :string, :after => :interval_time
  end
end
