require 'rails_helper'

describe Api::V1::ToursController, :type => :request do
  let(:user) { create :user }
  let(:tours) { create_list(:tour, 10) }

  before(:all) do
    header 'api-key', user.api_token
  end

  describe 'GET /api/v1/tours' do
    before do
      get '/api/v1/tours'
    end

    it 'returns tours' do
      expect(json).not_to be_empty
      expect(json['tours']).not_to be_empty
    end
  end

end
