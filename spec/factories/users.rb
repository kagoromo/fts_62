FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "foobar#{n}@example.com"}
    name Faker::Name.name
    password "password"
    password_confirmation "password"
    chatwork_id "123456789"

    factory :user_without_name do
      name nil
    end
  end
end
