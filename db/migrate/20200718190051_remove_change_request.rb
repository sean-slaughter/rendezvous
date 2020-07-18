class RemoveChangeRequest < ActiveRecord::Migration
  def change
    remove_column :appointments, :change_request, :boolean
  end
end
