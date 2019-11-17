FactoryBot.define do
  factory :tour do
    user {User.first || association(:user)}
  end
end