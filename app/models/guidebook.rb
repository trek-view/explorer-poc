class Guidebook < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_and_belongs_to_many :photos
  has_many :guidebooks_photos

  validates :name, presence: true, length: { maximum: 70 }
  validates :description, presence: true, length: { maximum: 240 }
end
