require 'rails_helper'

RSpec.describe Booking, type: :model do

  before(:each) do
    @user = create(:user)
  end

  it "has a valid factory" do
    expect(build(:booking)).to be_valid
  end

  describe "when making a booking and inserting a valid start date and end date" do
    it "should create a booking for the specified period" do

      start_at = DateTime.now + 2.days
      end_at = DateTime.now + 5.days

      vehicle_booking = build(:booking, start_at: start_at, end_at: end_at)

      expect(vehicle_booking).to be_valid
    end
  end

  describe "when making a booking and inserting a start date after an end date" do
    it "should not create a booking for the specified period" do

      start_at = DateTime.now + 7.days
      end_at = DateTime.now + 5.days

      vehicle_booking = build(:booking, start_at: start_at, end_at: end_at)

      expect(vehicle_booking).not_to be_valid
    end
  end

  describe "when making a booking(same vehicle) for a period between two other bookings" do
    it "should allow to create it " do
      booking_before = create(:booking, vehicle_id: 1,
                                         user: @user,
                                         start_at: DateTime.tomorrow.beginning_of_day,
                                         end_at: DateTime.tomorrow.beginning_of_day + 5.days )
      booking_after = create(:booking, vehicle_id: 1,
                                         user: @user,
                                         start_at: DateTime.tomorrow.beginning_of_day + 11.days,
                                         end_at: DateTime.tomorrow.beginning_of_day + 16.days )

      booking = build(:booking, vehicle_id: 1,
                                 user: @user,
                                 start_at: DateTime.tomorrow.beginning_of_day + 6.days,
                                 end_at: DateTime.tomorrow.beginning_of_day + 10.days )

      expect(booking.valid?).to eq(true)
    end
  end

  describe "when making a booking(same vehicle) that ends exactly in the minute before another booking starts" do
    it "should allow to create it" do
      booking_after = create(:booking, vehicle_id: 1,
                                         user: @user,
                                         start_at: DateTime.tomorrow.beginning_of_day + 11.days,
                                         end_at: DateTime.tomorrow.beginning_of_day + 16.days )

      booking = build(:booking, vehicle_id: 1,
                                 user: @user,
                                 start_at: DateTime.tomorrow.beginning_of_day + 6.days,
                                 end_at: DateTime.tomorrow.end_of_day + 10.days )

       expect(booking.valid?).to eq(true)
    end
  end

  describe "when making a booking(same vehicle) that starts exactly in the minute after another booking ends" do
    it "should allow to create it" do
      booking_before = create(:booking, vehicle_id: 1,
                                         user: @user,
                                         start_at: DateTime.tomorrow.beginning_of_day + 11.days,
                                         end_at: DateTime.tomorrow.end_of_day + 16.days )

      booking = build(:booking, vehicle_id: 1,
                                 user: @user,
                                 start_at: DateTime.tomorrow.beginning_of_day + 17.days,
                                 end_at: DateTime.tomorrow.beginning_of_day + 18.days )

      expect(booking.valid?).to eq(true)
    end
  end

  describe "when making a booking(same vehicle) that is fully inside another booking, in terms of period" do
    it "should not allow to create it" do
      booking_before = create(:booking, vehicle_id: 1,
                                         user: @user,
                                         start_at: DateTime.tomorrow.beginning_of_day + 11.days,
                                         end_at: DateTime.tomorrow.end_of_day + 16.days )

      booking = build(:booking, vehicle_id: 1,
                                 user: @user,
                                 start_at: DateTime.tomorrow.beginning_of_day + 12.days,
                                 end_at: DateTime.tomorrow.beginning_of_day + 15.days )

      expect(booking.valid?).to eq(false)
    end
  end

  describe "when making a booking(same vehicle) that is partially inside another booking, in terms of period" do
    it "should not allow to create it" do
      booking_before = create(:booking, vehicle_id: 1,
                                         user: @user,
                                         start_at: DateTime.tomorrow.beginning_of_day + 11.days,
                                         end_at: DateTime.tomorrow.end_of_day + 16.days )

      booking = build(:booking, vehicle_id: 1,
                                 user: @user,
                                 start_at: DateTime.tomorrow.beginning_of_day + 8.days,
                                 end_at: DateTime.tomorrow.beginning_of_day + 12.days )

      expect(booking.valid?).to eq(false)
    end
  end

  describe "when making a booking that overlaps another user booking, but they are for different vehicles" do
    it "should allow to create it" do
      booking_before = create(:booking, vehicle_id: 2,
                                         user: @user,
                                         start_at: DateTime.tomorrow.beginning_of_day + 11.days,
                                         end_at: DateTime.tomorrow.end_of_day + 16.days )

      booking = build(:booking, vehicle_id: 1,
                                 user: @user,
                                 start_at: DateTime.tomorrow.beginning_of_day + 8.days,
                                 end_at: DateTime.tomorrow.beginning_of_day + 12.days )

      expect(booking.valid?).to eq(true)
    end
  end

end
