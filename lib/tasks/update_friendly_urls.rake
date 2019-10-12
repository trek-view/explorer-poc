namespace :friendly_id do
  desc 'update models friendly-id slugs(set nil to regenerate)'
  task update_urls: :environment do

    Tour.find_each do |tour|
      tour.slug = nil
      tour.save
    end
    User.find_each do |user|
      user.slug = nil
      user.save
    end
    TourBook.find_each do |tour_book|
      tour_book.slug = nil
      tour_book.save
    end

  end
end
