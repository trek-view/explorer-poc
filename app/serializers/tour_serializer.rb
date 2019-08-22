# frozen_string_literal: true
class TourSerializer < ActiveModel::Serializer

  attributes %i[
                id
                name
                description
                country
                google_link
                tour_type
                tags
              ]

  def country
    object.country.try(:name)
  end

  def tags
    object.tag_names
  end

  has_many :photos

end
