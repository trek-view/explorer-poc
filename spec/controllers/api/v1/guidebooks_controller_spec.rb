require 'rails_helper'

require Rails.root.join('spec', 'controllers', 'api', 'v1', 'shared_examples', 'respond_to_missing.rb')

# describe Api::V1::GuidebooksController, :type => :controller do

#   let(:guidebook) { create :guidebook }

#   describe 'GET /api/v1/guidebooks/:guidebook_id' do
#     context 'when the guidebook exists' do
#       before do
#         header 'api-key', guidebook.api_token
#         get "/api/v1/guidebooks/#{guidebook.id}"
#       end

#       it 'should return the guidebook' do
#         expect(json['guidebook']).not_to be_empty
#         expect(json['guidebook']['id']).to eq(guidebook.id)
#         expect(json['guidebook']['name']).to eq(guidebook.name)
#       end
#     end

#     context 'when the guidebook does not exist' do
#       it_behaves_like "respond to missing", '/api/v1/guidebooks/-1'
#     end
#   end

#   describe 'GET /api/v1/guidebooks' do
#     context 'when the guidebook exists' do
#       before do
#         header 'api-key', guidebook.api_token
#         get "/api/v1/guidebooks"
#       end

#       it 'should return the guidebook' do
#         expect(json['guidebook']).not_to be_empty
#         expect(json['guidebook']['id']).to eq(guidebook.id)
#         expect(json['guidebook']['name']).to eq(guidebook.name)
#         expect(json['guidebook']['description']).to eq(guidebook.description)
#       end
#     end
#   end



# end
