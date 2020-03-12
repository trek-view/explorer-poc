class Tag < ApplicationRecord

  has_many :taggings
  has_many :tours, through: :taggings
  has_and_belongs_to_many :scenes
  has_and_belongs_to_many :guidebooks

  validates :name, presence: true, uniqueness: true

  before_create :lower_name

  def lower_name
    name.strip.downcase
  end

  def scenes_ids
    scenes_tags.map { |st| st.scene.id }.uniq
  end

  def scenes
    Scene.where(id: scenes_ids)
  end
end
