require 'rails_helper'

RSpec.describe User, type: :model do

  it "has a valid factory" do
    expect(create(:user)).to be_valid
  end

  describe "when signup with a valid email an password " do
    it "is supposed to create a new valid user" do

      email = "j.rosa@runtime-revolution"
      password = "12345678"

      user = create(:user, email: email, password: password)

      expect(user).to be_valid
    end
  end

  describe "when signup with a not valid email an password " do
    it "is supposed to don't create a new user" do

      email = "j.rosaruntime-revolution"
      password = "12345678"

      user = build(:user, email: email, password: password)

      expect(user).not_to be_valid
    end
  end

  describe "when signup with a valid email and not a valid password " do
    it "is supposed to don't create a new user" do

      email = "j.rosa@runtime-revolution"
      password = "12345"

      user = build(:user, email: email, password: password)

      expect(user).not_to be_valid
    end
  end

end