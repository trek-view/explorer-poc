# frozen_string_literal: true
class UsersController < ApplicationController

  before_action :authenticate_user!, except: [:tours]
  before_action :set_user

  def show
    result = ToursFinder.new(params, @user).search
    @tours = result[:tours]
    @tourbooks = result[:tourbooks]
    @sort = result[:sort]
    @query = result[:query]
    @search_text = result[:search_text]
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
      if params[:user_id].present?
        @user = User.friendly.find(params[:user_id])
      else
        @user = User.friendly.find(params[:id])
      end

    end

    def set_sort_params
      @sort = sort_params[:sort]
    end

    def sort_params
      params.permit(sort: [:tours, :tourbooks])
    end
    
end
