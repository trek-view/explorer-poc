require 'rails_helper'
require Rails.root.join('spec', 'controllers', 'api', 'v1', 'shared_examples', 'respond_to_empty.rb')

describe Api::V1::TourbooksController, :type => :controller do
  let!(:user) { create :user }
  let!(:tourbooks) { create_list(:tourbook, 2, :with_tours) }
  let (:tourbook_id) { tourbooks.first.id }
  let (:user_id) { user.id }

  describe 'GET /api/v1/tourbooks' do
    context 'When tourbooks exist' do
      before do
        header 'api-key', user.api_token
        tours = tourbooks.first.tours
        get "/api/v1/users/#{user.id}/tourbooks?tour_ids=#{[tours.first.id]}&sort_by=name"
      end

      it 'should return json with metadata', focus:true do
        p json
        expect(json).not_to be_empty
        expect(json['tourbooks']).not_to be_empty
        expect(json['_metadata']).not_to be_empty
      end

      it 'should return HTTP code 200' do
        expect(response).to have_http_status(:ok)
      end
    end
  end

end