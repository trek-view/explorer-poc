# frozen_string_literal: true
class UsersController < ApplicationController
  include MetaTagsHelper

  before_action :authenticate_user!, except: %i[tours show]
  before_action :set_user

  def show
    @home_cards = HomeCard.all.order(:priority)
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

  def submit_request_apikey
    authorize @user
    UserMailer.with(user: @user).submit_require_apikey_email.deliver_now
    if @user.errors.any?
      respond_to do |format|
        format.js {  flash[:error] = "Cannot submit to require API key usage." }
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
    params.permit(sort: %i[tours tourbooks guidebooks])
  end
end
