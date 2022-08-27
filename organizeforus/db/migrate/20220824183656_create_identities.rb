class CreateIdentities < ActiveRecord::Migration[7.0]
  def change
    create_table :identities do |t|
      t.integer :user_id
      t.string :provider
      t.string :uid

      t.timestamps

      t.index [:provider, :uid]
      t.index :user_id
    end
  end
end
