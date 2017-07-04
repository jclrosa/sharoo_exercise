FactoryGirl.define do

  factory :booking do
    vehicle_id 1
    start_at { DateTime.now }
    end_at { DateTime.now + Faker::Number.number(3).to_i.days }
    user { FactoryGirl.create(:user, email: Faker::Internet.email) }
  end
end
