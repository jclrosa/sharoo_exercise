require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  before(:each) do
    @user = create(:user)
  end

  describe "POST create" do
    it "have success response (200) and login user" do
      post :create, params: { user: { email: @user.email,
                                      password: @user.password }}
      assert_response :success
    end
  end
end
