require 'rails_helper'

RSpec.describe BookingsController, type: :controller do

  before(:each) do
    @user = create(:user)
    @request.headers['Authorization'] = @user.access_token
  end

  describe "GET index" do
    it "list all user bookings as @bookings" do
      booking = create(:booking, user: @user)
      get :index
      assert_response :success
    end
  end

  describe "GET show" do
    it "have success response (200)" do
      booking = create(:booking, user: @user)
      get :show, params: { id: booking.id }
      assert_response :success
    end
  end

  describe "POST create" do
    it "have success response (200) an create the bookings" do
      post :create, params: { bookings: [{vehicle_id: Faker::Number.number(7),
                                          start_at: "2017-07-06",
                                          end_at:"2017-07-16"}]}
      assert_response :success
    end
  end

  describe "POST create" do
    it "have success response (409) and not create the bookings" do
      booking = create(:booking, vehicle_id: Faker::Number.number(7),
                                 start_at: "2017-07-06",
                                 end_at:"2017-07-16" )

      post :create, params: { bookings: [{vehicle_id: booking.vehicle_id,
                                          start_at: booking.start_at,
                                          end_at:booking.end_at}]}
      assert_response :conflict
    end
  end

  describe "POST start" do
    it "have success response (200) and start the booking" do
      booking = create(:booking, user: @user)
      post :start, params: { id: booking.id }
      assert_response :success
    end
  end

end
