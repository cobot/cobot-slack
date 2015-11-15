class Space < ActiveRecord::Base
  has_many :admins
  has_many :teams

  validates :subdomain, uniqueness: true
end
