class TourBook < ApplicationRecord

  extend FriendlyId

  belongs_to :user

  has_many :booked_tours, dependent: :destroy
  has_many :tours, -> { distinct }, through: :booked_tours

  validates :name, presence: true, uniqueness: {scope: :user}, length: { maximum: 70 }
  validates :description, presence: true, length: { maximum: 240 }

  paginates_per Constants::ITEMS_PER_PAGE[:tour_books]
  friendly_id :name, use: :slugged

  def should_generate_new_friendly_id?
    name_changed?
  end

end
