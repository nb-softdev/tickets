class AddTicketSecretToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :ticket_secret, :string, :after => :user_id
  end
end
