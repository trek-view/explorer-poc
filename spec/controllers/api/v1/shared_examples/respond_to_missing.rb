RSpec.shared_examples 'respond to missing' do |url|

  let(:user) { create :user }

  before do
    header "api-key", user.api_token
  end

  it 'should respond with error' do
    expect do
      get url
    end.to raise_error(ActiveRecord::RecordNotFound)
  end

end