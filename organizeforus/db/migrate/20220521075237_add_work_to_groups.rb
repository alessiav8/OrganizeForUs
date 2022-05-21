class AddWorkToGroups < ActiveRecord::Migration[7.0]
  def change
    add_column :groups, :work, :boolean
  end
end
