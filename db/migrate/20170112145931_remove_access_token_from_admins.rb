class RemoveAccessTokenFromAdmins < ActiveRecord::Migration
  def change
    remove_column :admins, :access_token, :string
  end
end
