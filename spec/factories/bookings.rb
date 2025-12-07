FactoryBot.define do
  factory :booking do
    association :item
    association :renter, factory: :user, role: "renter"
    association :owner, factory: :user, role: "owner"
    start_date { Date.today }
    end_date { Date.tomorrow }
    status { :requested }

    trait :requested do
      status { :requested }
    end

    trait :approved do
      status { :approved }
    end
  end
end

