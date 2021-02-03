class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    enable_extension 'uuid-ossp'
    create_table :users, id: :uuid do |t|
      t.string :cobot_id
      t.timestamps
    end
  end
end
