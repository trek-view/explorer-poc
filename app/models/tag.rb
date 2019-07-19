class Tag < ApplicationRecord

  has_many :taggings
  has_many :tours, through: :taggings

end
