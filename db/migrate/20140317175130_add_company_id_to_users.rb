class AddCompanyIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :company_id, :integer, :after => :id
    add_column :tickets, :company_id, :integer, :after => :user_id
  end
end