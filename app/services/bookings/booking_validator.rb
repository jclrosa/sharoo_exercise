class Bookings::BookingValidator

  def initialize(booking)
    @booking = booking
  end

  def overlaps_timeframe?
    overlap_query = "bookings.start_at <= ? AND bookings.end_at > ? OR " +
                    "bookings.start_at < ? AND bookings.end_at >= ? "
    vehicle_bookings = Booking.where(vehicle_id: @booking.vehicle_id)
                              .where(overlap_query, @booking.start_at, @booking.start_at, @booking.end_at, @booking.end_at)
                              .exists?
    return false if !vehicle_bookings
    true
  end

end