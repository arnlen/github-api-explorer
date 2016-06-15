FactoryGirl.define do
  factory :repository do
    name            { Faker::App.name }
    stars           0
    creation_date   Date.today
  end
end
