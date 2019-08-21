class Tag < ApplicationRecord

  has_many :taggings
  has_many :tours, through: :taggings

  validates :name, presence: true, uniqueness: true
  validates_length_of :name, minimum: 1, maximum: 15
  validates_format_of :name,
                      with: /\A[a-zA-Z0-9]*\z/,
                      message: 'should not contain whitespaces or special characters'

  before_create :lower_name

  def lower_name
    name.strip.downcase
  end

end
