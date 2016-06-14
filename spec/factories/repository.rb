FactoryGirl.define do
  factory :repository do
    name            { Faker::App.name }
    creation_date   Date.today
  end
end
