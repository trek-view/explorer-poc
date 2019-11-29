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
    set_sort_params

    @tours = @user.tours.includes(:photos, :countries, :tags)

    if @sort.present?
      @tours = @tours.order(:name) if @sort[:tours] == 'name'
      @tours = @tours.order( tourbooks_count: :desc) if @sort[:tours] == 'tourbooks_count'
    end

    @tours = @tours.order(created_at: :desc)
    @tours = @tours.page(params[:page])
  end

  private

    def set_user
      @user = User.friendly.find(params[:user_id])
    end

    def set_sort_params
      @sort = sort_params[:sort]
    end

    def sort_params
      params.permit(sort: [:tours, :tourbooks])
    end
    
end
