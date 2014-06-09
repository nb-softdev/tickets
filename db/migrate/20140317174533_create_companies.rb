class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.string :business_type
      t.string :phone
      t.string :mobile
      t.text :address
      t.string :email
      t.string :logo
      t.string :url
      t.string :sub_domain
      t.boolean :is_active, :default => false
      t.boolean :is_confirmed, :default => false
      t.timestamps
    end
  end
end
