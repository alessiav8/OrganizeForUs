class CreatePositions < ActiveRecord::Migration[7.0]
  def change
    create_table :positions do |t|
      t.string :street
      t.string :city
      t.string :string
      t.string :country
      t.string :province
      t.decimal :latitude, precision: 10, scale:6
      t.decimal :longitude, precision: 10, scale:6
      t.references :event, null: false, foreign_key: true


      t.timestamps
    end
  end
end
