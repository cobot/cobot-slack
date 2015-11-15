class User < ActiveRecord::Base
  has_many :admins
  has_many :spaces, through: :admins

  def admin_for_space(space)
    admins.where(space_id: space.id).first
  end

  def access_token(space)
    admin_for_space(space).access_token
  end
end
