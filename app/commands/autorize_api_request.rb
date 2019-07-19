# frozen_string_literal: true
class AuthorizeApiRequest

  def initialize(headers={})
    @headers = headers
  end

  def call
    user
  end

  private

    def user
      user = User.find_by(api_token: get_headers_token) if get_headers_token
      user || errors.add(authorization: 'Invalid token') && nil
    end

    def get_headers_token
      if @headers['Tour-Api-Token'].present?
        @headers['Tour-Api-Token']
      else
        errors.add(:authorization, 'Missing token')
        nil
      end
    end

end