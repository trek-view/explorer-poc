FactoryBot.define do
  factory :tour do
    name { Faker::Name.name }
    description { Faker::Lorem.sentence }
    tag_names { "#{Faker::Name.name}, #{Faker::Name.name}" }
    tour_type { Constants::TOUR_TYPES[:land] }

    user {User.first || association(:user)}

    trait :with_photos do
      after(:create) do |tour|
        create_list(:photo, 2, tour: tour)
      end
    end
  end
end