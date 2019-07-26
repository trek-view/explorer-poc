# frozen_string_literal: true
class UsersController < ApplicationController

  before_action :authenticate_user!
  before_action :set_user

  def info
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

  def tours
    authorize @user

    @tours = current_user.tours
    @tours = @tours.page(params[:page])
  end

  private

    def set_user
      @user = User.friendly.find(params[:user_id])
    end

end
