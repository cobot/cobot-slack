# frozen_string_literal: true

class CreateAdmins < ActiveRecord::Migration[5.2]
  def change
    create_table :admins, id: :uuid do |t|
      t.uuid :space_id
      t.uuid :user_id
      t.string :access_token
      t.timestamps
    end
  end
end
