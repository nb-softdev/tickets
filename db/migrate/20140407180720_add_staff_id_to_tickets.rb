class AddStaffIdToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :staff_id, :integer, :after => :company_id
  end
end
