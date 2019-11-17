RSpec.shared_examples 'respond to missing' do |url|

  let(:user) { create :user }

  before do
    header "api-key", user.api_token
  end

  it 'responds with 404' do
    expect do
      get url
    end.to raise_error(ActiveRecord::RecordNotFound)
  end

end