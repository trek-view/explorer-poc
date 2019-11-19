FactoryBot.define do
  factory :streetview do
    photo_id { "MyString" }
    capture_time { "2019-11-18 18:47:04" }
    share_link { "MyText" }
    download_url { "MyText" }
    thumbnail_url { "MyText" }
    lat { "9.99" }
    lon { "9.99" }
    altitude { 1 }
    heading { 1 }
    pitch { 1 }
    roll { 1 }
    level { 1 }
    connections { "MyText" }
  end
end
