class HomeController < ApplicationController
  def index
    find_tours
    find_tour_books
    @tours = @tours.page(params[:page])
    @tour_books = @tour_books.page(params[:page])
  end

  def find_tours
    set_search_params
    @tours = Tour.includes(:photos, :countries, :tags, :user).order(created_at: 'DESC')

    if @query.present?
      @tours = @tours.joins(:countries).where('countries.id =?', @query['country_id'] ) if @query['country_id'].present?

      @tours = @tours.where(tour_type: @query['tour_type']) if @query['tour_type'].present?
    end
    @tours = @tours.search(@search_text) if @search_text.present?
  end

  def find_tour_books
    set_search_params
    @tour_books = TourBook.includes(:user, tours: :photos).order(created_at: 'DESC')
    @tour_books = @tour_books.search(@search_text) if @search_text.present?
  end

  private
    def set_search_params
      @search_text = search_params[:search_text]
      @query = search_params[:query]
    end

    def search_params
      params.permit(:search_text, query: [:country_id, :tour_type])
    end
end
