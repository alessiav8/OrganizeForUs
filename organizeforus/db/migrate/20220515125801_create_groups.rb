class CreateGroups < ActiveRecord::Migration[7.0]
  def change
    #questa è la migration non ancora pushata, fatta con
    #rails g scaffold group nome:string descrizione:string
    create_table :groups do |t|
      t.string :nome
      t.string :descrizione

      t.timestamps
    end
  end
end
