# frozen_string_literal: true
require 'uri'
class PhotoSerializer < ActiveModel::Serializer

  attributes %i[
                 id
                 tour_id
                 filename
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

  def filename
    if object.image.present?
      uri = URI.parse(object.image.url)
      File.basename(uri.path)
    else
      ''
    end
  end

end
