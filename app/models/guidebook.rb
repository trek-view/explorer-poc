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
    scenes.map { |s| s.photo.id }.uniq
  end

  def photos
    Photo.where(id: photos_ids)
  end

  def sponsors_ids
    ids = []
    user.tours.map { |t| ids = ids + t.sponsors_ids }.uniq
    ids.uniq
  end

  def sponsors
    Sponsor.where(id: sponsors_ids)
  end

  def last_position
    scenes.maximum(:position) || 0
  end

  def have_photo(photo_id)
    scenes.where(photo_id: 12).first ? true : false
  end
end
