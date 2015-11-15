class CreateAdmins < ActiveRecord::Migration
  def change
    create_table :admins, id: :uuid do |t|
      t.uuid :space_id
      t.uuid :user_id
      t.string :access_token
      t.timestamps
    end
  end
end
