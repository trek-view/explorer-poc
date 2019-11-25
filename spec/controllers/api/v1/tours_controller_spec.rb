require 'rails_helper'
require Rails.root.join('spec', 'controllers', 'api', 'v1', 'shared_examples', 'respond_to_empty.rb')

describe Api::V1::ToursController, :type => :controller do

  let!(:user) { create :user }
  let!(:tours) { create_list(:tour, 2, :with_photos) }
  let(:tour_id) { tours.first.id }

  describe 'GET /api/v1/tours' do
    context 'when tours exist', focus: true do
      before do
        header 'api-key', user.api_token
        get "/api/v1/tours?tags[]=#{tours.first.tags[0].name}&user_id=#{user.id}&ids[]=#{tours.first.id}&countries[]=#{tours.first.photos.first.country.code}"
      end

      it 'should return tours' do
        expect(json).not_to be_empty
        expect(json['_metadata']).not_to be_empty
        expect(json['tours']).not_to be_empty
        json['tours'].each do |tour|
          expect(tour.keys).to contain_exactly('id',
                                          'name',
                                          'description',
                                          'countries',
                                          'tour_type',
                                          'transport_type',
                                          'tags',
                                          'tourer_version',
                                          'tourer_tour_id',
                                          'created_at',
                                          'updated_at',
                                          'user_id')
        end
      end

      it 'should return status code 200' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when tours do not exist' do
      it_behaves_like "respond to empty", '/api/v1/tours?countries[]=xx'
      it_behaves_like "respond to empty", '/api/v1/tours?tags[]=xxx'
      it_behaves_like "respond to empty", '/api/v1/tours?user_id=-1'
    end
  end

  describe 'GET /api/v1/tours/:id' do
    context 'when tours exist' do
      before do
        header 'api-key', user.api_token
        get "/api/v1/tours/#{tours.first.id}"
      end

      it 'should return tours' do
        expect(json).not_to be_empty
        expect(json['tour']).not_to be_empty
      end

      it 'should return status code 200' do
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'POST /api/v1/tours' do
    let(:valid_attributes) do
      {
        name: "My tour of Windsor castle",
        description: "I did not meet the queen",
        tags: "royal, castle, history",
        tour_type: "land",
        transport_type: "bike",
        tourer_tour_id: "TR00399",
        tourer_version: "1.0"
      }
    end

    context 'when the request is valid' do
      before do
        header 'api-key', user.api_token
        post '/api/v1/tours', tour: valid_attributes
      end

      it 'should create a tour' do
        expect(json).not_to be_empty
        expect(json['tour']).not_to be_empty
      end

      it 'should return status code 201' do
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'PUT /api/v1/tours/:tour_id' do
    let(:valid_attributes) do
      {
          name: "My tour of Windsor castle",
          description: "I did not meet the queen",
          tags: "royal, castle, history",
          tour_type: "land",
          transport_type: "bike",
          tourer_tour_id: "TR00399",
          tourer_version: "1.0"
      }
    end

    context 'when the request is valid' do
      before do
        header 'api-key', user.api_token
        put "/api/v1/tours/#{tour_id}", tour: valid_attributes
      end

      it 'should update the tour' do
        expect(json).not_to be_empty
        expect(json['tour']).not_to be_empty
      end

      it 'should return status code 200' do
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'DELETE /api/v1/tours/:id' do
    before do
      header 'api-key', user.api_token
      delete "/api/v1/tours/#{tour_id}"
    end

    it 'returns status code 204' do
      expect(response).to have_http_status(200)
    end
  end
end
