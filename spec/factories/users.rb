FactoryGirl.define do

  factory :user do
    email Faker::Internet.email
    password Faker::Number.number(10)
    access_token Faker::Number.number(32)
  end
end