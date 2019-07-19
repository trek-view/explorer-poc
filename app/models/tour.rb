class Tour < ApplicationRecord

  belongs_to :country
  belongs_to :user

  has_many :taggings
  has_many :tags, through: :taggings

  accepts_nested_attributes_for :country
  accepts_nested_attributes_for :tags

  validates :name, presence: true, uniqueness: true

end
