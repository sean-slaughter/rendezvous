class RemoveChangeRequest < ActiveRecord::Migration[4.2]

  def change
    remove_column :appointments, :change_request, :boolean
  end
end
