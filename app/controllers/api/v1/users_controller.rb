module Api::V1
  class UsersController < BaseController
    
    def show
      @user = User.find(params[:id])
      render json: @user, status: :ok
    end
    
    def current_account
      resp = {
        user: {
          id: @api_user.id,
          name: @api_user.name,
          email: @api_user.email
        }
      }
      render json: resp, status: :ok
    end
  end
end