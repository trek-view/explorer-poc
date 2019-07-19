# frozen_string_literal: true
module API::V1
  class BaseController < ActionController::API

    before_action :authorize_request

    private

      def authorize_request
        @api_user = AuthorizeApiRequest(request.headers)
      end

  end
end
