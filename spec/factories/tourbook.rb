FactoryBot.define do
  factory :tourbook do
    name { Faker::Lorem.characters(number: 10) }
    description { Faker::Lorem.characters(number: 20) }

    user { User.first || association(:user) }

    trait :with_tours do
      after(:create) do |tourbook|
        create_list(:tour, 2, tourbooks: [tourbook])
      end
    end
  end
end