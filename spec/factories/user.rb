FactoryGirl.define do
  factory :user do
    sequence(:username)   { |n| "user#{n}" }
    stars                 0
  end
end
