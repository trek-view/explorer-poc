# frozen_string_literal: true
require 'uri'
class PhotoSerializer < ActiveModel::Serializer

  attributes %i[
                 id
                 tour_id
                 image
                 filename
                 taken_at
                 latitude
                 longitude
                 elevation_meters
                 address
                 google
                 streetview
                 tourer
                 opentrailview
                 created_at
                 updated_at
               ]

  def country
    object.country.present? ? object.country.name : ''
  end

end
