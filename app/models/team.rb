class Team < ActiveRecord::Base
  belongs_to :space

  validates :name, presence: true
  validates :slack_token, presence: true
  validates :slack_url, presence: true

  attr_accessor :invite_existing_members, :remove_canceled_members
end
