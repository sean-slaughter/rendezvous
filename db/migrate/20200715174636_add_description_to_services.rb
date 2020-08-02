class AddDescriptionToServices < ActiveRecord::Migration[4.2]

  def change
    add_column :services, :description, :string
  end
end
