class AddAccessTokenToSpaces < ActiveRecord::Migration
  def change
    add_column :spaces, :access_token, :string
    Space.reset_column_information
    Space.all.each do |space|
      space.update_attribute :access_token, Admin.where(space_id: space.id).first&.access_token
    end
  end
end
