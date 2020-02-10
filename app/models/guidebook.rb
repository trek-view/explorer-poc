class Guidebook < ApplicationRecord
  include PgSearch::Model
  belongs_to :user
  belongs_to :category
  has_many :scenes

  validates :name, presence: true, length: { maximum: 70 }
  validates :description, presence: true, length: { maximum: 240 }

  paginates_per Constants::ITEMS_PER_PAGE[:guidebooks]

  def build_scenes(scenes)
    if scenes.present?
      scenes.each do |scene|
        self.scene.build(
          photo_id: scene.photo_id,
          description: scene.description,
          position: scene.position
        )
        # self.tour_tourbooks.build(tour_id: tour.id) if tour
      end
    end
  end

  def scenes_count
    scenes.count
  end

  def photos_ids
    scenes.map { |s| s.photo.id }
  end

  def photos
    Photo.where(id: self.photos_ids)
  end
end
