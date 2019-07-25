# frozen_string_literal: true
class AuthorizeApiRequest

  prepend SimpleCommand

  attr_reader :messages

  def initialize(headers={})
    @headers = headers
    @messages = {}
  end

  def call
    {user: user, messages: @messages}
  end

  private

    def user
      if get_headers_token
        user = User.find_by(api_token: get_headers_token)
        @messages.store(:authorization, 'Invalid token') unless user
        user
      end
    end

    def get_headers_token
      if @headers['Tour-Api-Token'].present?
        @headers['Tour-Api-Token']
      else
        @messages.store(:authorization, 'Missing token')
        nil
      end
    end

end