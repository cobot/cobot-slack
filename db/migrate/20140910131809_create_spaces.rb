class CreateSpaces < ActiveRecord::Migration
  def change
    create_table :spaces, id: :uuid do |t|
      t.string :subdomain, :name
      t.timestamps
    end
  end
end
