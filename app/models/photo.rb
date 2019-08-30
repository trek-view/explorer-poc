class Photo < ApplicationRecord

  belongs_to :tour

  validates :file_name, presence: true, uniqueness: { scope: :tour_id }, length: { maximum: 50 }
  validates :taken_date_time, presence: true
  validates :latitude , numericality: { greater_than_or_equal_to:  -90, less_than_or_equal_to:  90 }, length: { maximum: 20 }
  validates :longitude, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }, length: { maximum: 20 }
  validates :country_code, inclusion: { in: ISO3166::Country.all.map(&:alpha2) }
  validates :elevation_meters, numericality: true, length: { maximum: 6 }
  validates :heading, numericality: true, length: { maximum: 20 }
  validates :street_view_thumbnail_url, presence: true, length: { maximum: 500 }, http_url: true
  validates :street_view_url, presence: true, length: { maximum: 500 }, http_url: true
  validates :connection, length: { maximum: 70 }
  validates :connection_distance_km, numericality: true, length: { maximum: 6 }
  validates :tourer_photo_id, presence: true, uniqueness: true, length: { maximum: 10 }

end
