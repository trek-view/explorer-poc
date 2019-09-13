class PhotoCountry < ApplicationRecord

  belongs_to :photo
  belongs_to :country

end
