FactoryBot.define do
  factory :dispute do
    association :item
    association :created_by, factory: :user
    reason { Faker::Lorem.sentence }
    details { Faker::Lorem.paragraph }
    status { "open" }

    trait :open do
      status { "open" }
    end

    trait :resolved do
      status { "resolved" }
      association :resolved_by, factory: :user, role: "admin"
      resolved_at { Time.current }
      resolution_notes { Faker::Lorem.paragraph }
    end

    trait :with_booking do
      association :booking
    end
  end
end

