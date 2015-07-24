FactoryGirl.define do
  factory :user do
    name 'Denis'
    sequence(:email) { |n| "email#{n}@gmail.com" }
    password 'pw'
  end
end
