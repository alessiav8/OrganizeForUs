class CreateMembers < ActiveRecord::Migration[7.0]
  def change
    create_table :members do |t|
      t.string :user_email, null: false
      t.references :group, null: false, foreign_key: true
      t.string :invito, default: "not accepted"
      t.string :iscritto
      
      t.timestamps
    end
  end
end
