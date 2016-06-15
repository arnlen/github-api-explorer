FactoryGirl.define do
  factory :user do
    sequence(:username)   { |n| "user#{n}" }
    followers             0
  end
end
