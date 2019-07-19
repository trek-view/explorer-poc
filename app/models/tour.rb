class Tour < ApplicationRecord

  belongs_to :country
  belongs_to :user

  # has_many :taggings
  # has_many :tags, through: :taggings

end
