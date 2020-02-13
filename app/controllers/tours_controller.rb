# frozen_string_literal: true
class ToursController < ApplicationController
  include MetaTagsHelper
  # before_action :authenticate_user!, only: %i[show]
  before_action :set_tours_search_params, only: [:index]
  before_action :set_user, only: %i[index show]
  before_action :set_tour, only: %i[show]

  def index
    @tours = @user ? @user.tours : Tour.all
    search_tours
    @tours = @tours.order(created_at: :desc)
    @tours = @tours.page(params[:page]).per(
      Constants::WEB_ITEMS_PER_PAGE[:tours]
    )
  end

  def show
    set_sort_params
    @photos = @tour.photos
    @tourbooks = @tour.tourbooks

    if @sort.present?
      if @sort[:photos] == 'taken_at'
        @photos = @photos.order(taken_at: :desc)
      elsif @sort[:photos] == 'filename'
        @photos = @photos.order(filename: :asc)
      end

      @tourbooks = @tourbooks.order(name: :desc) if @sort[:tourbooks] == 'name'
      @tourbooks = @tourbooks.order('tourbooks.tours_count DESC') if @sort[:tourbooks] == 'tours_count'
    end
    @photos = @photos.order('substring(favoritable_score from 15)::integer ASC')
    @tourbooks = @tourbooks.order(created_at: :desc)

    @photos = @photos.page(params[:photo_pagina]).per(Constants::WEB_ITEMS_PER_PAGE[:tours])
    @tourbooks = @tourbooks.page(params[:tourbook_pagina]).per(Constants::WEB_ITEMS_PER_PAGE[:tourbooks])

    tour_og_meta_tag(@tour)
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
    params.permit(:search_text, query: %i[country_id tour_type transport_type])
  end

  def set_sort_params
    @sort = sort_params[:sort]
  end

  def sort_params
    params.permit(sort: %i[photos tourbooks])
  end

  def set_user
    @user = if params[:user_id]
              User.friendly.find(params[:user_id])
            elsif params[:user]
              User.friendly.find(params[:id])
            end
  end

  def search_tours
    if @search_text.present?
      @tours = @tours.where(
        'lower(name) LIKE ?', '%' + @search_text.downcase + '%'
      ).or(
        @tours.where(
          'lower(description) LIKE ?', '%' + @search_text.downcase + '%'
        )
      )
    end
    # @tours.search(@search_text) if @search_text.present?
    return unless @query.present?

    if @query[:country_id].present?
      # somthing
    end
    @tours = @tours.where(tour_type: @query[:tour_type]) if @query[:tour_type].present?
    @tours = @tours.where(transport_type: @query[:transport_type]) if @query[:transport_type].present?
  end
end
