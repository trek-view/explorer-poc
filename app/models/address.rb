class Address < ApplicationRecord
  validates :cafe, length: { maximum: 255 }
  validates :road, length: { maximum: 255 }
  validates :suburb, length: { maximum: 255 }
  validates :county, length: { maximum: 255 }
  validates :region, length: { maximum: 255 }
  validates :state, length: { maximum: 255 }
  validates :postcode, length: { maximum: 6 }, format: { with: /[0-9]+/ }
  validates :country, presence: true, length: { maximum: 255 }
  validates :country_code, presence: true, inclusion: { in: ISO3166::Country.all.map(&:alpha2) }
end
