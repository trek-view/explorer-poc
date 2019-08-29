# frozen_string_literal: true
class ToursController < ApplicationController

  include MetaTagsHelper

  before_action :set_tour, only: %i[show]

  def index
    find_tours
    @tours = @tours.page(params[:page])
  end

  def show; end

  # for ajax search
  def search_tours
    find_tours
    render layout: false
  end

  def find_tours
    set_tours_search_params

    @tours = Tour.includes(:country, :tags, :user).order(created_at: 'DESC')

    if @query.present?
      @query.each do |key, val|
        @tours = @tours.where(key => val) if val.present?
      end
    end
    @tours = @tours.search(@search_text) if @search_text.present?
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