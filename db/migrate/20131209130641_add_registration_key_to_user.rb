class AddRegistrationKeyToUser < ActiveRecord::Migration
  def change
    add_column :users, :registration_key, :string, :after => :is_active
  end
end
