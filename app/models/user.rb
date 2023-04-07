class User < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: true
  has_many :followers

  before_create :generate_credentials

  def generate_credentials
    self.key = Digest::MD5.hexdigest Time.now.to_i.to_s
    self.secret = SecureRandom.uuid
  end

  def following
    Follower.following_user(id)
  end
end
