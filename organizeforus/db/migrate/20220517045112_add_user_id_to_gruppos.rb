class AddUserIdToGruppos < ActiveRecord::Migration[7.0]
  def change
    add_column :gruppos, :user_id, :integer
    add_index :gruppos, :user_id
  end
end
