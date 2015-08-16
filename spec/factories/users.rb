FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "username#{n}" }
    email { "#{username}@castlighthealth.com" }
    password "password"
  end
end
