# frozen_string_literal: true
class AuthorizeApiRequest

  prepend SimpleCommand

  def initialize(headers={})
    @headers = headers
  end

  def call
    user
  end

  private

    def user
      if get_headers_token
        user = User.find_by(api_token: get_headers_token)
        errors.add(authorization: 'Invalid token') unless user
        user
      else
        errors.add(authorization: 'No token found') && nil
      end
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