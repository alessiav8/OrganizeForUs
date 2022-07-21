class CreatePartecipations < ActiveRecord::Migration[7.0]
  def change
    create_table :partecipations do |t|
      t.string :role, default: "No Role"
      t.belongs_to :user
      t.belongs_to :group
      t.string :role_color, default: "#000000"
      t.boolean :accepted, default: "false"
      t.timestamps
      add_foreign_key :groups, :users

    end
  end
end