# frozen_string_literal: true

class RemoveAccessTokenFromAdmins < ActiveRecord::Migration[5.2]
  def change
    remove_column :admins, :access_token, :string
  end
end
