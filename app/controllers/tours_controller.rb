# frozen_string_literal: true
class ToursController < ApplicationController

  include MetaTagsHelper

  before_action :authenticate_user!, only: %i[set_photo_view_point
                                              unset_photo_view_point]
  before_action :set_tour, only: %i[show
                                    set_photo_view_point
                                    unset_photo_view_point]

  def index
    @tours = @tours.page(params[:page])
  end

  def show
    set_sort_params
    @photos = @tour.photos
    if @sort.present?
      @photos = @photos.order(taken_at: :desc) if @sort[:photos] == 'taken_at'
    end
    @photos = @photos.order('favoritable_total::integer DESC')
  end

  def set_photo_view_point
    @photo = @tour.photos.find_by(id: params[:photo_id])
    if @photo.present?
      current_user.favorite(@photo)
    else
      @photo.errors.add(:base, 'Cannot viewpoint this photo.')
    end
    redirect_to user_tour_path(current_user, @tour)
  end

  def unset_photo_view_point
    @photo = @tour.photos.find_by(id: params[:photo_id])
    if @photo.present?
      current_user.unfavorite(@photo)
    else
      @photo.errors.add(:base, 'Cannot unset viewpoint for this photo.')
    end
    redirect_to user_tour_path(current_user, @tour)
  end

  private

    def set_tour
      @tour = Tour.includes(:countries).friendly.find(params[:id])
    end

    def set_tours_search_params
      @search_text = tour_search_params[:search_text]
      @query = tour_search_params[:query]
    end

    def tour_search_params
      params.permit(:search_text, query: [:country_id, :tour_type])
    end

  def set_sort_params
    @sort = sort_params[:sort]
  end

  def sort_params
    params.permit(sort: [:photos])
  end

end
