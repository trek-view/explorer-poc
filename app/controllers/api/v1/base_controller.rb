# frozen_string_literal: true
module Api::V1
  class BaseController < ActionController::API

    before_action :authorize_request, except: [:user_not_authorized]

    attr_reader :api_user

    def user_not_authorized
      render json: {errors: {authorization: 'Unauthorized'}}, status: :unauthorized
    end

    private

      def authorize_request
        result = AuthorizeApiRequest.call(request.headers).result
        @api_user = result[:user]

        render json: {errors: result[:messages]}, status: 401 unless @api_user
      end

  end
end
