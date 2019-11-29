class HomeController < ApplicationController
  def index
    find_tours
    find_tourbooks
    @tours = @tours.page(params[:page])
    @tourbooks = @tourbooks.page(params[:page])
  end

  def find_tours
    set_search_params
    set_sort_params
    @tours = Tour.includes(:countries, :taggings, :tags, :user, photos: :country).references(:countries)

    if @query.present?
      @tours = @tours.where('countries.id =?', @query['country_id'] ) if @query['country_id'].present?
      @tours = @tours.where(tour_type: @query['tour_type']) if @query['tour_type'].present?
    end

    @tours = @tours.search(@search_text) if @search_text.present?

    if @sort.present?
      @tours = @tours.order(:name) if @sort[:tours] == 'name'
      @tours = @tours.order("tours.tourbooks_count DESC") if @sort[:tours] == 'tourbooks_count'
    end
    @tours = @tours.order(created_at: :desc)
  end

  def find_tourbooks
    tour_ids = @tours.present? ? @tours.map(&:id) : []
    @tourbooks = Tourbook.includes(:user, :tour_tourbooks, tours: :photos)
                     .references(:tours)
                     .where(tours: { id: tour_ids })
                     .distinct
    if @sort.present?
      @tourbooks = @tourbooks.order('tourbooks.name ASC') if @sort[:tourbooks] == 'name'
    end
    @tourbooks = @tourbooks.order('tourbooks.created_at DESC')
  end

  private

  def set_search_params
    @search_text = search_params[:search_text]
    @query = search_params[:query]
  end

  def set_sort_params
    @sort = sort_params[:sort]
  end

  def search_params
    params.permit(:search_text, query: [:country_id, :tour_type])
  end

  def sort_params
    params.permit(sort: [:tours, :tourbooks])
  end
end
