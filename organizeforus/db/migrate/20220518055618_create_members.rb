class CreateMembers < ActiveRecord::Migration[7.0]
  def change
    create_table :members do |t|
      t.string :user_email, null: false
      t.references :group, null: false, foreign_key: true
      t.string :invito, default: "not confirmed"
      t.string :driver, default: nil
      t.string :iscritto
      t.string :role, null: true
      t.string :necessary, null: true
      
      t.timestamps
    end
  end
end
