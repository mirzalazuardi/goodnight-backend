class Follower < ApplicationRecord
  validates :user_id, uniqueness: { scope: :follower_id }
  belongs_to :user
  belongs_to :follower, class_name: 'User'
  scope :following_user, ->(id) { where(follower_id: id) }

  #friend
  def self.follow_each_other_user_ids(uid)
    fu = where(user_id: uid).to_sql
    ff = following_user(uid).to_sql
    q = "select ff.user_id from (#{fu}) fu "\
      "inner join (#{ff}) ff on fu.follower_id = ff.user_id"
    ActiveRecord::Base.connection.execute(q).flat_map(&:values)
  end
end
