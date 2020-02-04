class Guidebook < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_and_belongs_to_many :photos
  has_many :guidebooks_photos

  validates :name, presence: true, length: { maximum: 70 }
  validates :description, presence: true, length: { maximum: 240 }
  
  def build_guidebooks_photos(guidebooks_photos)
    puts "===== build_guidebooks_photos: guidebooks_photos: #{guidebooks_photos.inspect}"
    if guidebooks_photos.present?
      guidebooks_photos.each do |guidebooks_photo|
        self.guidebooks_photo.build(
          photo_id: guidebooks_photo.photo_id,
          description: guidebooks_photo.description,
          position: guidebooks_photo.position
        )
        # self.tour_tourbooks.build(tour_id: tour.id) if tour
      end
    end
  end
end
