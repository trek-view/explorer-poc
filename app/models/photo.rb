class Photo < ApplicationRecord

  belongs_to :tour

  validates :file_name, presence: true, uniqueness: { scope: :tour_id }, length: { maximum: 50 }
  validates :taken_date_time, presence: true
  validates :latitude , numericality: { greater_than_or_equal_to:  -90, less_than_or_equal_to:  90 }
  validates :longitude, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }
  validates :country_code, inclusion: { in: ISO3166::Country.all.map(&:alpha2) }
  validates :elevation_meters, presence: true
  validates :heading, numericality: true
  validates :street_view_thumbnail_url, presence: true
  validates :street_view_url, presence: true
  validates :tourer_photo_id, presence: true, uniqueness: true, length: { maximum: 5 }

end
