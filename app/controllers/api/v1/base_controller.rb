# frozen_string_literal: true
module Api::V1
  class BaseController < ActionController::API

    before_action :authorize_request

    attr_reader :api_user

    private

      def authorize_request
        @api_user = AuthorizeApiRequest.call(request.headers).result
        render json: {authorize: 'Not Authorized'}, status: 401 unless @api_user
      end

  end
end
