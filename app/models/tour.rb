# frozen_string_literal: true
class Tour < ApplicationRecord

  include PgSearch::Model
  extend FriendlyId

  enum tour_type: Constants::TOUR_TYPES

  belongs_to :country
  belongs_to :user

  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  validates :name, presence: true
  validates :local_id, presence: true, uniqueness: true
  validates_inclusion_of :tour_type,
                         in: Constants::TOUR_TYPES.stringify_keys.keys,
                         message: "Tour type %s is not included in the list"

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
