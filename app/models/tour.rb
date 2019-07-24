# frozen_string_literal: true
class Tour < ApplicationRecord

  include PgSearch::Model
  extend FriendlyId

  belongs_to :country
  belongs_to :user

  has_many :taggings
  has_many :tags, through: :taggings

  validates :name, presence: true, uniqueness: true

  enum tour_type: { land: 0, water: 1, air: 2 }

  friendly_id :name, use: :slugged

  pg_search_scope :search,
                  against: [
                      :name,
                      :description
                  ],
                  associated_against: {
                      tags: [:name],
                      country: [:name]
                  }

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
