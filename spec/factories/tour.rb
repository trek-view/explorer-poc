FactoryBot.define do
  factory :tour do
    name { Faker::Name.name }
    description { Faker::Lorem.sentence }
    tag_names { "#{Faker::Name.name}, #{Faker::Name.name}" }
    tour_type { Constants::TOUR_TYPES[:land] }

    user {User.first || association(:user)}
  end
end