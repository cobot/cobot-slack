class Admin < ActiveRecord::Base
  belongs_to :space
  belongs_to :user

  validates :space_id, uniqueness: {scope: :user_id}
end
