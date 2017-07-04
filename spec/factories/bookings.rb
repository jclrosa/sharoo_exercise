FactoryGirl.define do
  factory :booking do
    vehicle_id 1
    start_at { Date.today }
    end_at { Date.today + Faker::Number.number(3).to_i.days }
    user { FactoryGirl.create :user }
  end
end
