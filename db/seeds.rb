require 'factory_bot_rails'

unless Rails.env.production?
  unless User.first
    test_user = User.new(
      name: 'Johnny', email: 'test_user@example.com',
      password: 'password',
      password_confirmation: 'password'
    )
    test_user.skip_confirmation!
    test_user.save!
    FactoryBot.create_list(:tour, 6, :with_photos, user: test_user)

    4.times do
      user = FactoryBot.create(:confirmed_user)
      FactoryBot.create_list(:tour, 6, :with_photos, user: user)
    end
  end

  unless Tourbook.first
    FactoryBot.create_list(:tourbook, 3, :with_tours, user: User.first)
  end
end

# Create default four home cards.
unless HomeCard.first
  HomeCard.create!(
    title: 'Tours', description: 'Journeys though our natural world',
    priority: 1, avatar: '1.png', url: '/tours', icon: 'dribbble'
  )
  HomeCard.create!(
    title: 'Tourbooks', description: 'Groups of tours curated for you to explore',
    priority: 2, avatar: '2.png', url: '/tourbooks', icon: 'creative-commons'
  )
  HomeCard.create!(
    title: 'Viewpoints', description: 'The photos fellow Explorers like the most',
    priority: 3, avatar: '3.png', url: '/viewpoints', icon: 'map-marker'
  )
  HomeCard.create!(
    title: 'Guidebooks', description: 'Travel around the world on educational adventures',
    priority: 4, avatar: '4.png', url: '/guidebooks', icon: 'suitcase'
  )
end

# Create default categories for guidbooks.
unless Category.first
  Category.create!(name: 'Architecture')
  Category.create!(name: 'Culture')
  Category.create!(name: 'Environment')
  Category.create!(name: 'History')
  Category.create!(name: 'Transport')
  Category.create!(name: 'Places')
end

unless AdminUser.first
  AdminUser.create!(
    email: ENV['ADMIN_EMAIL'],
    password: ENV['ADMIN_PASSWORD'],
    password_confirmation: ENV['ADMIN_PASSWORD']
  )
end
