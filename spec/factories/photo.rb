FactoryBot.define do
  factory :photo do
    taken_at { 1.day.ago }
    latitude { "-20.516189" }
    longitude { "44.533069" }
    elevation_meters { "745" }
    camera_make { Faker::Lorem.characters(number:5) }
    camera_model { Faker::Lorem.characters(number:5) }
    google {{
        plus_code_global_code: Faker::Lorem.characters(number: 10),
        plus_code_compound_code: Faker::Lorem.characters(number:30)
    }}
    address {{
        cafe: '',
        road: '',
        suburb: '',
        county: '',
        region: '',
        state: '',
        postcode: '',
        country: Faker::Address.country,
        country_code: Faker::Address.country_code
    }}
    streetview {{
        photo_id: Faker::Lorem.characters(number:10),
        capture_time: 1.day.ago,
        share_link: Faker::Internet.url,
        download_url: Faker::Internet.url,
        thumbnail_url: Faker::Internet.url,
        "lat": -20.516189,
        "lon": 44.533069,
        altitude: 745,
        heading: 90,
        pitch: 90,
        roll: 90,
        level: 1,
        connections: [
          738475838,
          738475839
        ]
    }}
    tourer {{
      photo_id: Faker::Lorem.characters(number:10),
      connection_photo: Faker::Lorem.characters(number:10),
      connection_method: "time",
      connection_distance_meters: 4,
      heading: 90
    }}
    image { Rack::Test::UploadedFile.new(Rails.root.join('spec/support/images/sample.jpeg'), 'image/jpeg') }
    tourer_photo_id { Faker::Lorem.characters(number:10) }
    country { Faker::Address.country_code }
    tour
  end
end