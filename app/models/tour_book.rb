class TourBook < ApplicationRecord

  extend FriendlyId

  belongs_to :user

  # has_many :added_tours
  # has_many :tours, through: :added_tours

  validates :name, presence: true
  validates :description, presence: true

  paginates_per Constants::ITEMS_PER_PAGE[:tour_books]
  friendly_id :name, use: :slugged

  def should_generate_new_friendly_id?
    name_changed?
  end

end
