class TourCountry < ApplicationRecord

  belongs_to :tour
  belongs_to :country

end
