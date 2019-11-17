require 'rails_helper'
require Rails.root.join('spec', 'controllers', 'api', 'v1', 'shared_examples', 'respond_to_empty.rb')

describe Api::V1::ToursController, :type => :api do
  let(:user) { create :user }
  let(:tours) { create_list(:tour, 10) }

  describe 'GET /api/v1/tours' do
    context 'when call without query params' do
      before do
        header 'api-key', user.api_token
        get '/api/v1/tours'
      end

      it 'returns tours' do
        expect(json).not_to be_empty
        expect(json['tours']).not_to be_empty
        expect(json['_metadata']).not_to be_empty
      end
    end

    context 'when call with query params' do
      it_behaves_like "respond to empty", '/api/v1/tours?country=xxx'
      it_behaves_like "respond to empty", '/api/v1/tours?tag=xxx'
      it_behaves_like "respond to empty", '/api/v1/tours?user_id=-1'
    end
  end

end
