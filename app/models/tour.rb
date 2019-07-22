# frozen_string_literal: true
class Tour < ApplicationRecord

  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :country
  belongs_to :user

  has_many :taggings
  has_many :tags, through: :taggings

  validates :name, presence: true, uniqueness: true

  paginates_per Constants::ITEMS_PER_PAGE[:tours]

  def country_name=(name)
    self.country = Country.where(name: name.strip.downcase).first_or_create!
  end

  def tag_names=(names_string)
    self.tags = names_string.split(',').map do |name|
      Tag.where(name: name.strip.downcase).first_or_create!
    end
  end

  def tag_names
    self.tags.map(&:name).join(', ')
  end

end
