# frozen_string_literal: true
class ToursController < ApplicationController

  include MetaTagsHelper

  before_action :authenticate_user!, only: %i[set_photo_view_point
                                              unset_photo_view_point]
  before_action :set_tour, only: %i[show
                                    set_photo_view_point
                                    unset_photo_view_point]

  def index
    find_tours
    @tours = @tours.page(params[:page])
  end

  def show
    @photos = @tour.photos.order(created_at: :desc)
  end

  # for ajax search
  def search_tours
    find_tours
    render layout: false
  end

  def find_tours
    set_tours_search_params

    @tours = Tour.includes(:photos, :countries, :tags, :user).order(created_at: :desc)

    if @query.present?
      @tours = @tours.joins(:countries).where('countries.id =?', @query['country_id'] ) if @query['country_id'].present?

      @tours = @tours.where(tour_type: @query['tour_type']) if @query['tour_type'].present?
    end
    @tours = @tours.search(@search_text) if @search_text.present?
  end

  def set_photo_view_point
    @photo = @tour.photos.find_by(id: params[:photo_id])
    if @photo.present?
      @photo.set_a_view_point(current_user)
    else
      @photo.errors.add(:base, 'Cannot viewpoint this photo.')
    end
    redirect_to user_tour_path(current_user, @tour)
  end

  def unset_photo_view_point
    @photo = @tour.photos.find_by(id: params[:photo_id])
    if @photo.present?
      @photo.clear_view_point(current_user)
    else
      @photo.errors.add(:base, 'Cannot unset viewpoint for this photo.')
    end
    redirect_to user_tour_path(current_user, @tour)
  end

  private

    def set_tour
      @tour = Tour.friendly.find(params[:id])
    end

    def set_tours_search_params
      @search_text = tour_search_params[:search_text]
      @query = tour_search_params[:query]
    end

    def tour_search_params
      params.permit(:search_text, query: [:country_id, :tour_type])
    end

end
