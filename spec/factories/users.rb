FactoryBot.define do
  factory :user do
    username do
      uname = Faker::Internet.username(specifier: 6..12, separators: ['_']).gsub(/[^a-zA-Z0-9_]/, '')
      uname = "user_#{uname}" unless uname.match?(/\A[a-zA-Z]/)
      uname[0..19]
    end
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

