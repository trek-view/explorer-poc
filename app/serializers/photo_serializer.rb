# frozen_string_literal: true
require 'uri'
class PhotoSerializer < ActiveModel::Serializer

  attributes %i[
    id
    tour_id
    image
    filename
    camera_make
    camera_model
    taken_at
    latitude
    longitude
    elevation_meters
    address
    streetview
    tourer
    opentrailview
    mapillary
    favoritable_score
    favoritable_total
    created_at
    updated_at
  ]

  def image
    {
      url: stripe_image_path(object.image.url),
      thumb: {
        url: stripe_image_path(object.image.thumb.url)
      },
      small: {
        url: stripe_image_path(object.image.small.url)
      },
      med: {
        url: stripe_image_path(object.image.med.url)
      }
    }
  end

  def country
    object.country.present? ? object.country.name : ''
  end

  def address
    {
        cafe: object.address['cafe'],
        road: object.address['road'],
        suburb: object.address['suburb'],
        county: object.address['county'],
        region: object.address['region'],
        state: object.address['state'],
        postal_code: object.address['postal_code'],
        country: object.address['country'],
        country_code: object.address['country_code'],
        place_id: object.address['place_id'],
        plus_code: object.address['plus_code']
    }
  end

  def streetview
    {
        photo_id: object.streetview['photo_id'],
        capture_time: object.streetview['capture_time'],
        share_link: object.streetview['share_link'],
        download_url: object.streetview['download_url'],
        thumbnail_url: object.streetview['thumbnail_url'],
        lat: object.streetview['lat'],
        lon: object.streetview['lon'],
        altitude: object.streetview['altitude'],
        heading: object.streetview['heading'],
        pitch: object.streetview['pitch'],
        roll: object.streetview['roll'],
        level: object.streetview['level'],
        connections: object.streetview['connections']
    }
  end

  def tourer
    return {} unless object.tourer

    if object.tourer['connections']
      connections = JSON.parse(object.tourer['connections'])
    else
      connections = {}
    end

    {
        photo_id: object.tourer['photo_id'],
        version: object.tourer['version'],
        heading_degrees: object.tourer['heading_degrees'],
        connections: connections
    }
  end

  def opentrailview
    {
        photo_id: object.opentrailview && object.opentrailview['photo_id']
    }
  end

  def mapillary
    {
        photo_id: object.mapillary && object.mapillary['photo_id']
    }
  end

  def stripe_image_path(image_path)
    image_path.gsub("s3.#{ENV['FOG_REGION']}.amazonaws.com/", '')
  end
end
