class Follower < ApplicationRecord
  belongs_to :user
  belongs_to :follower, class_name: 'User'
  scope :following_user, ->(id) { where(follower_id: id) }
end
