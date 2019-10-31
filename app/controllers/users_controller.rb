# frozen_string_literal: true
class UsersController < ApplicationController

  before_action :authenticate_user!, except: [:tours]
  before_action :set_user

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
    @tours = @user.tours
    @tours = @tours.page(params[:page])
  end

  private

    def set_user
      @user = User.friendly.find(params[:user_id])
    end
    
end
