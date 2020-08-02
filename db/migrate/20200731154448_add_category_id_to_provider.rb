class AddCategoryIdToProvider < ActiveRecord::Migration[4.2]

  def change
    add_column :providers, :category_id, :integer
  end
end
