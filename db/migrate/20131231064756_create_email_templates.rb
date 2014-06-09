class CreateEmailTemplates < ActiveRecord::Migration
  def change
    create_table :email_templates do |t|
      t.string :subject
      t.text :content
      t.string :email_type
      t.timestamps
    end
  end
end
