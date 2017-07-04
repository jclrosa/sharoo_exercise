class Booking < ApplicationRecord
  enum status: { scheduled: 0, started: 1}

  belongs_to :user

  validates :end_at, presence: true
  validates :start_at, presence: true
  validates :vehicle_id, presence: true
  validates :user_id, presence: true

  validate :end_at_after_start_at?

  #Don't allow to have bookings where the end_at date after the start at date
  def end_at_after_start_at?
    if end_at < start_at
      errors.add :end_at, "must be after start at date"
    end
  end
end
