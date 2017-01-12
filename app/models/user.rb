class User < ActiveRecord::Base
  has_many :admins
  has_many :spaces, through: :admins
end
