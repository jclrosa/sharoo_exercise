require 'rails_helper'

RSpec.describe Bookings::BookingValidator do

  it "should allow to make a booking(same vehicle) for a period between two other bookings" do
    user = create(:user)
    booking_before = create(:booking, vehicle_id: 1,
                                       user: user,
                                       start_at: DateTime.tomorrow.beginning_of_day,
                                       end_at: DateTime.tomorrow.beginning_of_day + 5.days )
    booking_after = create(:booking, vehicle_id: 1,
                                       user: user,
                                       start_at: DateTime.tomorrow.beginning_of_day + 11.days,
                                       end_at: DateTime.tomorrow.beginning_of_day + 16.days )

    booking = build(:booking, vehicle_id: 1,
                               user: user,
                               start_at: DateTime.tomorrow.beginning_of_day + 6.days,
                               end_at: DateTime.tomorrow.beginning_of_day + 10.days )

    validator_result = Bookings::BookingValidator.new(booking).overlaps_timeframe?
    expect(validator_result).to eq(false)
  end

  it "should allow to make a booking(same vehicle) that ends exactly in the minute before another booking starts" do
    user = create(:user)
    booking_after = create(:booking, vehicle_id: 1,
                                       user: user,
                                       start_at: DateTime.tomorrow.beginning_of_day + 11.days,
                                       end_at: DateTime.tomorrow.beginning_of_day + 16.days )

    booking = build(:booking, vehicle_id: 1,
                               user: user,
                               start_at: DateTime.tomorrow.beginning_of_day + 6.days,
                               end_at: DateTime.tomorrow.end_of_day + 10.days )

    validator_result = Bookings::BookingValidator.new(booking).overlaps_timeframe?
    expect(validator_result).to eq(false)
  end

  it "should allow to make a booking(same vehicle) that starts exactly in the minute after another booking ends" do
    user = create(:user)
    booking_before = create(:booking, vehicle_id: 1,
                                       user: user,
                                       start_at: DateTime.tomorrow.beginning_of_day + 11.days,
                                       end_at: DateTime.tomorrow.end_of_day + 16.days )

    booking = build(:booking, vehicle_id: 1,
                               user: user,
                               start_at: DateTime.tomorrow.beginning_of_day + 17.days,
                               end_at: DateTime.tomorrow.beginning_of_day + 18.days )

    validator_result = Bookings::BookingValidator.new(booking).overlaps_timeframe?
    expect(validator_result).to eq(false)
  end

  it "should not allow to make a booking(same vehicle) that is fully inside another booking, in terms of period" do
    user = create(:user)
    booking_before = create(:booking, vehicle_id: 1,
                                       user: user,
                                       start_at: DateTime.tomorrow.beginning_of_day + 11.days,
                                       end_at: DateTime.tomorrow.end_of_day + 16.days )

    booking = build(:booking, vehicle_id: 1,
                               user: user,
                               start_at: DateTime.tomorrow.beginning_of_day + 12.days,
                               end_at: DateTime.tomorrow.beginning_of_day + 15.days )

    validator_result = Bookings::BookingValidator.new(booking).overlaps_timeframe?
    expect(validator_result).to eq(true)
  end

  it "should not allow to make a booking(same vehicle) that is partially inside another booking, in terms of period" do
    user = create(:user)
    booking_before = create(:booking, vehicle_id: 1,
                                       user: user,
                                       start_at: DateTime.tomorrow.beginning_of_day + 11.days,
                                       end_at: DateTime.tomorrow.end_of_day + 16.days )

    booking = build(:booking, vehicle_id: 1,
                               user: user,
                               start_at: DateTime.tomorrow.beginning_of_day + 8.days,
                               end_at: DateTime.tomorrow.beginning_of_day + 12.days )

    validator_result = Bookings::BookingValidator.new(booking).overlaps_timeframe?
    expect(validator_result).to eq(true)
  end

  it "should allow to make a booking that overlaps another user booking, if they are for different vehicles" do
    user = create(:user)
    booking_before = create(:booking, vehicle_id: 2,
                                       user: user,
                                       start_at: DateTime.tomorrow.beginning_of_day + 11.days,
                                       end_at: DateTime.tomorrow.end_of_day + 16.days )

    booking = build(:booking, vehicle_id: 1,
                               user: user,
                               start_at: DateTime.tomorrow.beginning_of_day + 8.days,
                               end_at: DateTime.tomorrow.beginning_of_day + 12.days )

    validator_result = Bookings::BookingValidator.new(booking).overlaps_timeframe?
    expect(validator_result).to eq(false)
  end

end