module Api::V1
  class UsersController < BaseController
    def account_info
      user = {
        :id => @api_user.id,
        :name =>@api_user.name,
        :email => @api_user.email
      }
      render json: user, status: :ok
    end
  end
end