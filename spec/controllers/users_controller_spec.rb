require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe "POST create" do
    it "have success response (200) and create a user" do
      post :create, params: { user: { email: Faker::Internet.email,
                                      password: Faker::Number.number(10) }}
      assert_response :success
    end
  end
end
