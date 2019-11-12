FactoryBot.define do
  factory :user do
    name { "JohnDoe" }
    email { 'test@example.com' }
    password { 'password' }
  end
end