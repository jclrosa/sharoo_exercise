class Bookings::BookingValidator

  def initialize(booking)
    @booking = booking
  end

  def overlaps_timeframe?
    vehicle_bookings = Booking.where(vehicle_id: @booking.vehicle_id)

    return false if !vehicle_bookings.present?

    return true if vehicle_bookings.any? {|book| (@booking.start_at >= book.start_at && @booking.start_at < book.end_at ) ||
                                                 (@booking.end_at > book.start_at && @booking.end_at <= book.end_at )}

    false
  end

end