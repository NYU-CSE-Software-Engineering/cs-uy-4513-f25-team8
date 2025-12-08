FactoryBot.define do
  factory :item do
    title { Faker::Commerce.product_name }
    description { Faker::Lorem.paragraph }
    price { Faker::Commerce.price(range: 10.0..100.0) }
    category { ["Electronics", "Clothing", "Furniture", "Sports", "Other"].sample }
    availability_status { "available" }
    association :owner, factory: :user, role: "owner"

    trait :available do
      availability_status { "available" }
    end

    trait :unavailable do
      availability_status { "unavailable" }
    end

    trait :pending do
      availability_status { "pending" }
    end
  end
end

