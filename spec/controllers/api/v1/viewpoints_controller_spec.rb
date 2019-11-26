require 'rails_helper'

describe Api::V1::ViewpointsController, :type => :controller do

  let!(:user) { create :user }
  let!(:tours) { create_list(:tour, 1, :with_photos, user: user) }

  describe 'POST /api/v1/viewpoints' do
    let(:valid_attributes) do {
      photo_id: tours.first.photos.first.id
    }
    end

    context 'Mark viewpoint' do
      before do
        header 'api-key', user.api_token
        post '/api/v1/viewpoints', viewpoint: valid_attributes
      end

      it 'should return updated viewpoint with 1' do
        expect(json).not_to be_empty
        expect(json['viewpoint']).not_to be_empty
        expect(json['viewpoint']['viewpoint']).to equal(1)
      end
    end

    context 'Unmark viewpoint' do
      before do
        photo = tours.first.photos.first
        user.favorite(photo)
        header 'api-key', user.api_token
        post '/api/v1/viewpoints', viewpoint: valid_attributes
      end

      it 'should return updated viewpoint with 0' do
        expect(json).not_to be_empty
        expect(json['viewpoint']).not_to be_empty
        expect(json['viewpoint']['viewpoint']).to equal(0)
      end
    end
  end

  describe 'GET /api/v1/viewpoints?photo_id=', focus:true do
    before do
      photo = tours.first.photos.first
      user.favorite(photo)
      header 'api-key', user.api_token
      get "/api/v1/viewpoints?photo_id=#{photo.id}"
    end

    it 'should return viewpoint 1' do
      expect(json).not_to be_empty
      expect(json['viewpoint']).not_to be_empty
      expect(json['viewpoint']['viewpoint']).to equal(1)
    end
  end

end