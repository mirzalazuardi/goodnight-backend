class User < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: true
  has_many :followers

  after_initialize :generate_credentials, unless: :persisted?

  def generate_credentials
    self.key = Digest::MD5.hexdigest Time.now.to_i.to_s
    self.secret = SecureRandom.uuid
  end
end
