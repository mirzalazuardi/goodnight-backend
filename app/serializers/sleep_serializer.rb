class SleepSerializer
  include JSONAPI::Serializer
  attributes :user, :start, :finish, :duration_seconds, :duration

  belongs_to :user, serializer: UserSerializer

  attribute :user do |object|
    object.user.slice(:id, :name)
  end

  attribute :duration do |object|
    Sleep.human_readable_time(object.duration_seconds) 
  rescue
    "N/A"
  end
end
