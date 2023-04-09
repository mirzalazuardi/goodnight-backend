class Sleep < ApplicationRecord
  belongs_to :user

  scope :in_progress, ->(uid) { where(user_id: uid).where(finish: nil) }
  scope :completed, ->(uid) { where(user_id: uid).where.not(start:nil, finish: nil) }
  scope :last_week, -> { where(start: 7.days.ago.beginning_of_day..Time.now) }
  scope :desc_order_by_duration, -> { order(duration_seconds: :desc) }
  validates :start, presence: true

  def self.friends_sleeps(uid)
    where(user_id: Follower.follow_each_other_user_ids(uid))
      .last_week
      .desc_order_by_duration
  end

  def self.clock(uid)
    last_row = in_progress(uid)
    if last_row.present?
      now = Time.now
      diff = now - last_row[0].start
      return last_row[0].update_columns(finish: now, duration_seconds: diff) 
    end

    create!(user_id: uid, start: Time.now)
  end

  def self.human_readable_time(secs)
    [[60, :seconds], [60, :minutes], [24, :hours], [Float::INFINITY, :days]]
      .map do |count, name|
        next unless secs > 0

        secs, number = secs.divmod(count)
        duration_type = number == 1 ? name.to_s.delete_suffix('s') : name

        "#{number.to_i} #{duration_type}" unless number.to_i == 0
    end.compact.reverse.join(', ')
  end
end
