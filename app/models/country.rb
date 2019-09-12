class Country < ApplicationRecord

  has_many :tours

  validates :code, presence: true, uniqueness: true, inclusion: { in: ISO3166::Country.all.map(&:alpha2) }

  before_save :set_name

  def set_name
    country = ISO3166::Country.new(self.code)
    self.name = country.name if country
  end

end
