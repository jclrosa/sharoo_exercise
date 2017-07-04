require 'rails_helper'

RSpec.describe Booking, type: :model do
  it "has a valid factory" do
    expect(create(:booking)).to be_valid
  end

  describe "when making a booking and inserting a valid start date and end date" do
    it "should create a booking for the specified period" do

      start_at = Date.today + 2.days
      end_at = Date.today + 5.days

      vehicle_booking = create(:booking, start_at: start_at, end_at: end_at)

      expect(vehicle_booking).to be_valid
    end
  end

  describe "when making a booking and inserting a start date after an end date" do
    it "should not create a booking for the specified period" do

      start_at = Date.today + 7.days
      end_at = Date.today + 5.days

      vehicle_booking = build(:booking, start_at: start_at, end_at: end_at)

      expect(vehicle_booking).not_to be_valid
    end
  end

end
