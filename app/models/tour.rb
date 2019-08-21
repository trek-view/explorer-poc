# frozen_string_literal: true
class Tour < ApplicationRecord

  include PgSearch::Model
  extend FriendlyId

  enum tour_type: Constants::TOUR_TYPES

  belongs_to :country
  belongs_to :user

  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  has_many :photos, dependent: :destroy

  accepts_nested_attributes_for :photos
  accepts_nested_attributes_for :tags

  before_validation :find_or_init_tags

  validates :name, presence: true, uniqueness: { scope: :user_id }, length: { maximum: 70 }
  validates :description, length: { maximum: 140 }
  validates :local_id, presence: true, uniqueness: true, length: { maximum: 10 }

  validates_associated :photos
  validates_associated :tags

  validate :tags_amount
  validate :tour_type_should_be_valid

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

  # def country_name=(name)
  #   country = Country[name]
  #   self.country ||= country.name
  # end

  # for case if we will need to pass tags as a string and validate its length (add :tag_names to strong_params)
  def tag_names=(names_string)
    self.tags = names_string.split(',').map do |name|
      Tag.where(name: name.strip.downcase).first_or_create!
    end
  end

  def tag_names
    self.tags.map(&:name).join(', ')
  end
  #--------------------------------------------------------------------------

  def find_or_init_tags
    self.tags = self.tags.map do |tag|
      Tag.where(name: tag.name).first_or_initialize
    end
  end

  def tags_amount
    errors.add(:tags, "too much tags (maximum is #{Constants::TAGS_AMOUNT[:tour]} tags)") if tags.length > Constants::TAGS_AMOUNT[:tour]
  end

  # custom validation with message for enum :tour_type (as it raises ArgumentError in the case of wrong value)
  # standard validation doesn't help (validates_inclusion_of)
  def tour_type=(value)
    super value
    @tour_type_backup = nil
  rescue ArgumentError => exception
    error_message = 'is not a valid tour_type'
    if exception.message.include? error_message
      @tour_type_backup = value
      self[:tour_type] = nil
    else
      raise
    end
  end

  def tour_type_should_be_valid
    if @tour_type_backup
      error_message = "#{@tour_type_backup} is not a valid tour_type"
      errors.add(:tour_type, error_message)
    end
  end
  #---------------------------------------------------------------------------------------------------------

end






