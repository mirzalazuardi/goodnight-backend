class SleepSerializer
  include JSONAPI::Serializer
  attributes :user, :start, :finish, :duration

  belongs_to :user, serializer: UserSerializer

  attribute :user do |object|
    object.user.slice(:id, :name)
  end

  attribute :duration do |object|
    Sleep.human_readable_time(object.duration_seconds)
  end
end
