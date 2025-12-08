FactoryBot.define do
  factory :user do
    username { Faker::Internet.username }
    email { Faker::Internet.email }
    password { "password123" }
    role { "renter" }
    account_status { "active" }
    report_count { 0 }

    trait :renter do
      role { "renter" }
    end

    trait :owner do
      role { "owner" }
    end

    trait :admin do
      role { "admin" }
    end

    trait :disabled do
      account_status { "disabled" }
    end

    trait :active do
      account_status { "active" }
    end
  end
end

