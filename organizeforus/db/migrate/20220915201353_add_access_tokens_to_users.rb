class AddAccessTokensToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :gh_access_token, :string
    add_column :users, :fb_access_token, :string
    add_column :users, :gh_username, :string
    add_column :users, :fb_expires_at, :datetime
  end
end
