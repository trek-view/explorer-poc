# frozen_string_literal: true
class TourSerializer < ActiveModel::Serializer

  attributes %i[
                id
                name
                description
                countries
                tags
                tour_type
                transport_type
                tourer_version
                tourer_tour_id
              ]

  def countries
    object.countries.any? ? object.countries.pluck(:name) : []
  end

  def tags
    object.tag_names
  end

end
