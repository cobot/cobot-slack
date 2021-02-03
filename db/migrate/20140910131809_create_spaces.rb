# frozen_string_literal: true

class CreateSpaces < ActiveRecord::Migration[5.2]
  def change
    create_table :spaces, id: :uuid do |t|
      t.string :subdomain, :name
      t.timestamps
    end
  end
end
