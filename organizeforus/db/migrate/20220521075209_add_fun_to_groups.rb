class AddFunToGroups < ActiveRecord::Migration[7.0]
  def change
    add_column :groups, :fun, :boolean
  end
end
