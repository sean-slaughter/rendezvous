class CreateClients < ActiveRecord::Migration[4.2]

  def change
    create_table :clients do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :phone_number
      t.string :location
    end
  end
end
