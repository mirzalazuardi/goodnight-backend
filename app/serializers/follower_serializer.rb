class FollowerSerializer
  include JSONAPI::Serializer
  attributes :user, :follower

  belongs_to :user, serializer: UserSerializer
  belongs_to :follower, serializer: UserSerializer

  attribute :user do |object|
    object.user.slice(:id, :name)
  end

  attribute :follower do |object|
    object.follower.slice(:id, :name)
  end
end
