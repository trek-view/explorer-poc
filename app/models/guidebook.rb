class Guidebook < ApplicationRecord
  belongs_to :user
  belongs_to :category

  validates :name, presence: true, length: { maximum: 70 }
  validates :description, presence: true, length: { maximum: 240 }
end
