class Country < ApplicationRecord

  has_many :tours

  validates :name, presence: true, uniqueness: true

end
