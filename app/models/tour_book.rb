class TourBook < ApplicationRecord

  extend FriendlyId

  belongs_to :user

  has_many :booked_tours, dependent: :destroy
  has_many :tours, through: :booked_tours, inverse_of: :tour_books

  validates :name, presence: true, uniqueness: {scope: :user}, length: { maximum: 70 }
  validates :description, presence: true, length: { maximum: 240 }

  paginates_per Constants::ITEMS_PER_PAGE[:tour_books]
  friendly_id :name, use: :slugged

  def should_generate_new_friendly_id?
    name_changed?
  end

  def build_booked_tours(tour_ids)
    if tour_ids.present?
      tour_ids.each do |tour_id|
        tour = Tour.find_by(tourer_tour_id: tour_id)
        self.booked_tours.build(tour_id: tour.id) if tour
      end
    end
  end

end