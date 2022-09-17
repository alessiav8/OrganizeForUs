class CreateGroups < ActiveRecord::Migration[7.0]
  def change
    #questa è la migration non ancora pushata, fatta con
    #rails g scaffold group name:string description:string
    create_table :groups do |t|
      t.string :name
      t.string :description
      t.string :created, default: false
      t.integer :hours
      t.integer :min_hours_in_a_day, default: 1
      t.date :date_of_start
      t.date :date_of_end
      t.string :color, default: "#000000"
      t.string :organization
      t.string :git_repository
      t.time :start_hour
      t.time :end_hour
      t.timestamps
    end
  end
end
