# frozen_string_literal: true
class PhotoSerializer < ActiveModel::Serializer

  attributes %i[
                 id
                 tour_id
                 image
                 taken_at
                 latitude
                 longitude
                 elevation_meters
                 country
                 address
                 google
                 streetview
                 tourer
                 created_at
                 updated_at
               ]

  def country
    object.country.present? ? object.country.name : ''
  end

end
