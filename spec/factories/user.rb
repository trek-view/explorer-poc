FactoryBot.define do
  factory :user do
    name { Faker::Name.unique.name.gsub!(/[^0-9A-Za-z]/, '') }
    email { Faker::Internet.email }
    password { 'password' }

    factory :confirmed_user, :parent => :user do
      before(:create) { |user| user.skip_confirmation! }
    end
  end
end