# frozen_string_literal: true
class PhotoSerializer < ActiveModel::Serializer

  attributes %i[
                 id
                 tour_id
                 file_name
                 taken_date_time
                 latitude
                 longitude
                 elevation_meters
                 country
                 heading
                 street_view_url
                 street_view_thumbnail_url
                 connection
                 connection_distance_km
                 plus_code
                 camera_make
                 camera_model
                 tourer_photo_id
                 main_photo
                 view_points_count
                 streetview_id
               ]

  def country
    object.country.present? ? object.country.name : ''
  end

end
