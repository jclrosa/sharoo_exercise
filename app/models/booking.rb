class Booking < ApplicationRecord
  enum status: { scheduled: 0, started: 1}

  belongs_to :user

  validates :end_at, presence: true
  validates :start_at, presence: true
  validates :vehicle_id, presence: true
  validates :user_id, presence: true

  validate :overlaps_timeframe?
  validate :end_at_after_start_at?

  #Don't allow to have bookings where the end_at date after the start at date
  def end_at_after_start_at?
    if end_at < start_at
      errors.add :end_at, "must be after start at date"
    end
  end

  #Verify if the booking overlaps any other booking in the system
  def overlaps_timeframe?
    overlap_query = "bookings.start_at <= ? AND bookings.end_at > ? OR " +
                    "bookings.start_at < ? AND bookings.end_at >= ? "
    vehicle_bookings = Booking.where(vehicle_id: vehicle_id)
                              .where(overlap_query, start_at, start_at, end_at, end_at)
                              .exists?
    if vehicle_bookings
      errors.add :start_at, "already exist a vehicle booking to the same period "
    end
  end

end
