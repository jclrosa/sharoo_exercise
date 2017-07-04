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
    result_bookings = verify_booking_bookability

    #All bookings are successfully made
    if result_bookings[:iterator].count > 0 && result_bookings[:saved].count == result_bookings[:iterator].count
      render status: 200, json: { response: "Booking Vehicle created successfully",
                                  bookings: result_bookings[:bookings_list] }

    #Just part of the bookings could be made
    elsif result_bookings[:saved].count > 0 && result_bookings[:not_saved].count > 0 &&
          result_bookings[:saved].count != result_bookings[:iterator].count
      render status: 207, json: { multistatus: result_bookings[:saved] + result_bookings[:not_saved] , response: "Some bookings were not possible to be done"}

    #The booking is not possible because there are bookings for the same time period
    elsif result_bookings[:saved].count == 0 && result_bookings[:not_saved].count == result_bookings[:iterator].count
      render status: 409, json: { response: "There are already Vehicle Bookings for the requested period"}
    end
  end

  def show
    if @booking.present? && @booking.user == current_user
      render status: 200, json: { booking: @booking }
    elsif @booking.present? && @booking.user != current_user
      render status: 401, json: { response: "This booking is not yours, you don't have permissions to access it" }
    else
      render status: 404, json: { response: "The specified booking does not exist" }
    end
  end

  def start
    # Here I not defined any specific date time rule for a user to be able to start a booking.
    # I will just permit for a user to start future bookings.

    if @booking.present? && @booking.user == current_user &&
            DateTime.now.to_date <= @booking.start_at.to_date && @booking.scheduled?

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
    @booking = Booking.find_by_id(params[:id])
  end

  def booking_params
    params.require(:booking).permit(:vehicle_id, :start_at, :end_at)
  end

  def bookings_array_params
    params.require(:bookings).map{ |book| book.permit(:vehicle_id, :start_at, :end_at) }
  end

  def verify_booking_bookability
    #store the list of created bookings in json format
    bookings_saved = []
    #store the list of not created bookings in json format
    bookings_not_saved = []
    #store the list of bookings created
    bookings_list = []

    #store the params of a booking/bookings a logged in user wants to make
    booking_iterator = (params[:bookings].present? ? bookings_array_params : [booking_params] )

    booking_iterator.each do |book_param|
      booking = Booking.new(book_param)
      #Verifies if the desired booking for the logged in user can be done

      booking.user = current_user
      if booking.valid?
        booking.save
        bookings_saved.push({status: 200, id: booking.id })
        bookings_list.push(booking)
      else
        bookings_not_saved.push({status: 409, errors: booking.errors })
      end
    end
    { iterator: booking_iterator, bookings_list: bookings_list,
      saved: bookings_saved, not_saved: bookings_not_saved }
  end
end
