class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :start]

  #List of a logged in user bookings
  def index
    if current_user.bookings.count > 0
      render status: 200, json: { bookings: current_user.bookings}
    else
      render status: 200, json: { bookings: [], response: "User does not have any bookings yet"}
    end
  end

  #When assigning a set of bookings to be created, it will insert only the ones that
  #are possible to be made. The not poossible bookings will be sent in the request response
  def create
    result_bookings = create_bookings

    if result_bookings[:all_saved]
      render status:200, json: { response: "Booking Vehicle created successfully",
                                 bookings: result_bookings[:result].map(&:id) }

    elsif result_bookings[:all_failed]
      render status: 409, json: { response: "There are already Vehicle Bookings for the requested period"}
    else
      result = result_bookings[:result].map do |booking|
        if booking.new_record?
          { status: 409, errors: booking.errors.full_messages }
        else
          { status: 200, id: booking.id }
        end
      end
      render status: 207, json: { response: "Some bookings were not possible to be done",  multistatus:  result}
    end
  end

  def show
    if @booking.present?
      render status: 200, json: { booking: @booking }
    else
      render status: 404, json: { response: "The specified booking does not exist" }
    end
  end

  def start
    # Here I not defined any specific date time rule for a user to be able to start a booking.
    # I will just permit for a user to start future bookings.
    if @booking.present? && DateTime.now.to_date <= @booking.start_at.to_date &&
            @booking.scheduled?

      @booking.update_attributes(status: "started")
      render status: 200, json: { booking: @booking, response: "Booking successfully started" }
    elsif @booking.present? && @booking.user != current_user

      render status: 401, json: { response: "This booking is not yours, you don't have permissions to access it" }
    else

      render status: 404, json: { response: "The specified booking does not exist" }
    end
  end

private

  def set_booking
    @booking = Booking.find_by(id: params[:id], user: current_user)
  end

  def booking_params
    params.require(:booking).permit(:vehicle_id, :start_at, :end_at)
  end

  def bookings_array_params
    params.require(:bookings).map{ |book| book.permit(:vehicle_id, :start_at, :end_at) }
  end

  def create_bookings
    booking_iterator = (params[:bookings].present? ? bookings_array_params : [booking_params] )
    saved = 0
    result = booking_iterator.map do |book_param|
      booking = Booking.new(book_param)
      booking.user = current_user
      #Verifies if the desired booking for the logged in user can be done
      saved += 1 if booking.save
      booking
    end
    {
      all_saved: saved > 0 && saved == result.size,
      all_failed: saved == 0,
      result: result
    }
  end
end
