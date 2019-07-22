# frozen_string_literal: true
class UsersController < ApplicationController
  before_action :set_user

  def token_info
    authorize @user
  end

  def generate_new_token
    authorize @user

    @user.regenerate_api_token

    if @user.errors.any?
      respond_to do |format|
        format.js {  flash[:error] = "Cannot regenerate token" }
      end
    end
  end

  private

    def set_user
      @user = User.friendly.find(params[:user_id])
    end

end
