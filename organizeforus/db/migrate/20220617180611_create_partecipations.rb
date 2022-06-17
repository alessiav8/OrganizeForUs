class CreatePartecipations < ActiveRecord::Migration[7.0]
  def change
    create_table :partecipations do |t|
      t.string :role
      t.belongs_to :user
      t.belongs_to :group

      t.timestamps
      add_foreign_key :groups, :users

    end
  end
end
