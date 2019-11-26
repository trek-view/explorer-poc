FactoryBot.define do
  factory :tour do
    name { Faker::Lorem.characters(number: 10) }
    description { Faker::Lorem.sentence }
    tag_names { "#{Faker::Lorem.characters(number: 4)}, #{Faker::Lorem.characters(number: 5)}" }
    tour_type { Constants::TOUR_TYPES[:land] }
    user

    trait :with_photos do
      after(:create) do |tour|
        create_list(:photo, 1, tour: tour)
      end
    end
  end
end