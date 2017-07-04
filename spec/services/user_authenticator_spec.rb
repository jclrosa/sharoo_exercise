require 'rails_helper'

RSpec.describe Users::UserAuthenticator do

  it "should verify the user can be successfully authenticated with the used credentials" do
    user = create(:user, password: "password")
    authentication_result = Users::UserAuthenticator.new(user).authenticate("password") != false
    expect(authentication_result).to eq(true)
  end

  it "should not authenticate a user that uses a differente password" do
    user = create(:user, password: "password")
    authentication_result = Users::UserAuthenticator.new(user).authenticate("password1231") != false
    expect(authentication_result).to eq(false)
  end

end