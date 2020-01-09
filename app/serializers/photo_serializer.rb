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
                 favoritable_score
                 created_at
                 updated_at
               ]

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
        postcode: object.address['postcode'],
        country: object.address['country'],
        country_code: object.address['country_code']
    }
  end

  def google
    {
        plus_code_global_code: object.google['plus_code_global_code'],
        plus_code_compound_code: object.google['plus_code_compound_code']
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
        connections: connections
    }
  end

  def opentrailview
    {
        photo_id: object.opentrailview && object.opentrailview['photo_id']
    }
  end

  def favoritable_score
    object.favoritable_score[:favorite]
  end

end
