class HomeController < ApplicationController
  def index
    find_tours
    find_tourbooks
    @tours = @tours.page(params[:page])
    @tourbooks = @tourbooks.page(params[:page])
  end

  def find_tours
    set_search_params
    @tours = Tour.includes(:photos, :countries, :tags, :user).order(created_at: :desc)

    if @query.present?
      @tours = @tours.joins(:countries).where('countries.id =?', @query['country_id'] ) if @query['country_id'].present?

      @tours = @tours.where(tour_type: @query['tour_type']) if @query['tour_type'].present?
    end
    @tours = @tours.search(@search_text) if @search_text.present?
  end

  def find_tourbooks
    @tourbooks = Tourbook
                  .includes(:user, tours: :photos)
                  .order(created_at: :desc)

    return unless @search_text.present? ||
                  (@query.present? && (
                    @query['country_id'].present? ||
                    @query['tour_type'].present?
                  ))

    tour_ids = @tours.map(&:id)
    @tourbooks = Tourbook
                    .includes(:user, tours: :photos)
                    .joins(:tour_tourbooks)
                    .where('tour_tourbooks.tour_id in (?)', tour_ids)
                    .order(created_at: :desc)
                    .distinct
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
