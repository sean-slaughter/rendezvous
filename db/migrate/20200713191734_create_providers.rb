class CreateProviders < ActiveRecord::Migration
  def change
    create_table :providers do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :location
      t.string :phone_number
      t.string :business_name
    end
  end
end
