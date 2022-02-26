FactoryBot.define do
    factory :user do
      sequence(:email) { |n| "test-#{n.to_s.rjust(3, "0")}@sample.com" }
      username {'testuser'}
      password { "123456" }
      confirmed_at { DateTime.now }
    end
  end