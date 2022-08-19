class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.references :group, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :description
      t.string :type_of_presence
      t.string :type_of_houre
      t.integer :houres
      t.string :address
      t.string :city
      t.string :country

      t.timestamps
    end
  end
end
