class CreateGroups < ActiveRecord::Migration[7.0]
  def change
    #questa è la migration non ancora pushata, fatta con
    #rails g scaffold group name:string description:string
    create_table :groups do |t|
      t.string :name
      t.string :description
      t.string :created, default: false
      t.timestamps
    end
  end
end
