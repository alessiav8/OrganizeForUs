class AddAttributesToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :name, :string, required: true
    add_column :users, :surname, :string, required: true
    add_column :users, :username, :string, required: true
    add_column :users, :birthday, :date, required: true
   
  end
end
