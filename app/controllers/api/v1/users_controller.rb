module Api::V1
  class UsersController < BaseController
    def account_info
      resp = {
        account_info: {
          id: @api_user.id,
          name: @api_user.name,
          email: @api_user.email
        }
      }
      render json: resp, status: :ok
    end
  end
end