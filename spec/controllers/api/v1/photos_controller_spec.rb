require 'rails_helper'

describe Api::V1::PhotosController, :type => :controller do

  let!(:user) { create :user }
  let!(:tour) { create :tour, user: user }
  let!(:photos) { create_list(:photo, 2, tour: tour) }
  let(:tour_id) { tour.id }
  let(:photo_id) { photos.first.id }

  let(:valid_attributes) {{
      taken_at: 1.day.ago,
      latitude: -20.516189,
      longitude: 44.533069,
      elevation_meters: 745,
      camera_make: "GoPro",
      camera_model: "Fusion",
      google: {
          plus_code_global_code: "849VCWC8+R9",
          plus_code_compound_code: "CWC8+R9, Mountain View, CA, USA"
      },
      address: {
          cafe: '',
          road: '',
          suburb: '',
          county: '',
          region: '',
          state: '',
          postcode: '',
          country: "France",
          country_code: "FR"
      },
      streetview: {
          photo_id: "738475838",
          capture_time: "2019-10-01T12:00:01.000Z",
          share_link: "https://www.google.co.uk/maps/@-22.516189,45.5330688",
          download_url: "https://www.google.co.uk/maps/@-22.516189,45.5330688",
          thumbnail_url: "https://www.google.co.uk/maps/@-22.516189,45.5330688",
          lat: "-20.516189",
          lon: "44.533069",
          altitude: "745",
          heading: "90",
          pitch: "90",
          roll: "90",
          level: "1",
          connections: [
              738475838,
              738475839
          ]
      },
      tourer: {
          photo_id: "tkKjChLHbE",
          connection_photo: "fkujChLJJJ",
          connection_method: "time",
          connection_distance_meters: "4",
          heading: "90"
      },
      image: Rack::Test::UploadedFile.new(Rails.root.join('spec/support/images/sample.jpeg'), 'image/jpeg')
  }}

  describe 'GET /api/v1/tours/:tour_id/photos' do
    context 'When photos exists' do
      before do
        header 'api-key', user.api_token
        get "/api/v1/tours/#{tour_id}/photos?ids[]=#{photos.first.id}&countries[]=#{photos.first.country.code}&user_id=#{user.id}&sot_by=created_at"
      end

      it 'should return photos' do
        expect(json).not_to be_empty
        expect(json['_metadata']).not_to be_empty
        expect(json['photos']).not_to be_empty
        json['photos'].each do |photo|
          expect(photo.keys).to contain_exactly('id',
                                                'tour_id',
                                                'created_at',
                                                'updated_at',
                                                'taken_at',
                                                'user_id',
                                                'image',
                                                'latitude',
                                                'longitude',
                                                'elevation_meters',
                                                'country',
                                                'address',
                                                'google',
                                                'streetview',
                                                'tourer')
        end
      end

      it 'should return status code 200' do
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET /api/v1/tours/:tour_id/photos/:id' do
    context 'When photos exists' do
      before do
        header 'api-key', user.api_token
        get "/api/v1/tours/#{tour_id}/photos/#{photo_id}"
      end

      it 'should return photos' do
        expect(json).not_to be_empty
        expect(json['photo']).not_to be_empty
      end

      it 'should return status code 200' do
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'POST /api/v1/tours/:tour_id/photos' do
    context 'When the request is valid' do
      before do
        header 'api-key', user.api_token
        post "/api/v1/tours/#{tour_id}/photos", valid_attributes
      end

      it 'should create a photo' do
        expect(json).not_to be_empty
        expect(json['photo']).not_to be_empty
      end

      it 'should return status code 200' do
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'PUT /api/v1/tours/:tour_id/photos/:id' do
    before do
      header 'api-key', user.api_token
      put "/api/v1/tours/#{tour_id}/photos/#{photo_id}", valid_attributes
    end

    it 'should update the photo' do
      expect(json).not_to be_empty
      expect(json['photo']).not_to be_empty
    end

    it 'should return status code 200' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'DELETE /api/v1/tours/:tour_id/photos/:id' do
    before do
      header 'api-key', user.api_token
      delete "/api/v1/tours/#{tour_id}/photos/#{photo_id}"
    end

    it 'returns status code 204' do
      expect(response).to have_http_status(200)
    end
  end

end