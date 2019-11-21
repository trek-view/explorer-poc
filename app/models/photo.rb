# frozen_string_literal: true
class Photo < ApplicationRecord

  include PgSearch::Model

  mount_uploader :image, PhotoUploader

  belongs_to :tour
  belongs_to :country

  has_many :view_points, dependent: :destroy

  store_accessor :address, :cafe, :road, :suburb, :county, :region, :state, :postcode, :country_code
  store_accessor :google, :plus_code_global_code, :plus_code_compound_code
  store_accessor :streetview,  :capture_time, :share_link, :download_url, :thumbnail_url, :lat, :lon, :altitude, :heading, :pitch, :roll, :level, :connections
  store_accessor :tourer, :photo_id, :connection_method, :connection_photo, :connection_distance_meters

  validates :image, file_size: { less_than: 30.megabytes }
  validates :taken_at, presence: true
  validates :latitude , numericality: { greater_than_or_equal_to:  -90, less_than_or_equal_to:  90 }, length: { maximum: 20 }
  validates :longitude, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }, length: { maximum: 20 }
  validates :elevation_meters, numericality: true, length: { maximum: 6 }
  validates :camera_make, length: { maximum: 255 }
  validates :camera_model, length: { maximum: 255 }
  validates :country, presence: true
  validates :country_code, presence: true
  validates :plus_code_global_code, length: { maximum: 255 }
  validates :plus_code_compound_code, length: { maximum: 255 }
  validates :lat, numericality: { greater_than_or_equal_to:  -90, less_than_or_equal_to:  90 }, length: { maximum: 20 }
  validates :lon, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }, length: { maximum: 20 }
  validates :heading, numericality: { greater_than_or_equal_to:  0, less_than_or_equal_to:  360 }
  validates :pitch, numericality: { greater_than_or_equal_to:  -90, less_than_or_equal_to:  90 }
  validates :roll, numericality: { greater_than_or_equal_to:  0, less_than_or_equal_to:  360 }
  validates :photo_id, allow_blank: true, length: { maximum: 10 }
  validates :connection_distance_meters, numericality: true
  validates :tourer_photo_id, uniqueness: true, allow_blank: true, length: { maximum: 10 }

  validates_associated :country

  before_destroy :remove_image

  pg_search_scope :search,
                  against: [],
                  associated_against: {
                      country: [:code]
                  }
  paginates_per Constants::ITEMS_PER_PAGE[:photos]

  def country=(country_code)
    country = Country.find_or_create_by(code: country_code)
    super country
  end

  def check_view_points(user)
    self.view_points.where(user_id: user.id).any?
  end

  def clear_view_point(user)
    view_point = self.view_points.find_by(user_id: user.id)
    view_point.destroy if view_point
  end

  def set_a_view_point(user)
    self.view_points.create(user_id: user.id)
  end

  def s3_dir
    if User.current.present?
      "#{User.current.id}/#{self.tour.id}"
    else
      ""  
    end
    
  end

end
