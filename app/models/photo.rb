class Photo < ApplicationRecord

  belongs_to :tour

  validates :file_name, length: {maximum: 50}
  validates_uniqueness_of :file_name, scope: [:tour]
  validates :heading, numericality: true

end
