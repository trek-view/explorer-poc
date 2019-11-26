FactoryBot.define do
  factory :tourbook do
    name { Faker::Lorem.characters(number: 10) }
    description { Faker::Lorem.characters(number: 20) }
    user

    trait :with_tours do
      after(:create) do |tourbook|
        tourbook.tours << build_list(:tour, 2)
      end
    end
  end
end