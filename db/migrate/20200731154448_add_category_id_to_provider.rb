class AddCategoryIdToProvider < ActiveRecord::Migration
  def change
    add_column :providers, :category_id, :integer
  end
end
