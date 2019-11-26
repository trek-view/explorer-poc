require 'factory_bot_rails'

unless Rails.env.production?
  unless User.first
    5.times do
      user = FactoryBot.create(:confirmed_user)
      FactoryBot.create_list(:tourbook, 1, :with_tours, user: user)
    end
  end
end

AdminUser.create!(email: ENV['ADMIN_EMAIL'], password: ENV['ADMIN_PASSWORD'], password_confirmation: ENV['ADMIN_PASSWORD']) if Rails.env.development?