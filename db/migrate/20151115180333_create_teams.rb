# frozen_string_literal: true

class CreateTeams < ActiveRecord::Migration[5.2]
  def change
    create_table :teams, id: :uuid do |t|
      t.string :name, :slack_token, :slack_url
      t.uuid :space_id
    end
  end
end
