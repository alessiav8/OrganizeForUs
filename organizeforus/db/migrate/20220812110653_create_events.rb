class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.references :group, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
     
      t.string :title
      t.string :description
      t.datetime :start_date
      t.datetime :end_date
      t.string :members


      t.timestamps
    end
  end
end
