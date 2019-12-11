class Finder
  def initialize(params, user = nil)
    @params = params
    @user = user
  end

  def search
    set_search_params
    set_sort_params

    if @tab == 'tours'
      search_tours
    else
      search_tourbooks
    end

    @tours = @tours.page(@params[:tour_pagina]).per(Constants::WEB_ITEMS_PER_PAGE[:tours])
    @tourbooks = @tourbooks.page(@params[:tourbook_pagina]).per(Constants::WEB_ITEMS_PER_PAGE[:tourbooks])
    {
        tours: @tours,
        tourbooks: @tourbooks,
        sort: @sort,
        query: @query,
        search_text: @search_text,
        tab: @tab
    }

  end

  private

  def search_tours
    # look for tours
    find_all_tours

    if @query.present?
      @tours = @tours.where('countries.id =?', @query['country_id'] ) if @query['country_id'].present?
      @tours = @tours.where(tour_type: @query['tour_type']) if @query['tour_type'].present?
    end
    @tours = @tours.search(@search_text) if @search_text.present?

    sort_tours

    # look for tourbooks including tours
    find_alll_tourbooks

    tour_ids = @tours.present? ? @tours.map(&:id) : []
    @tourbooks = @tourbooks.includes(:user, :tour_tourbooks, tours: :photos)
                     .references(:tours)
                     .where(tours: { id: tour_ids })
                     .distinct
    sort_tourbooks
  end

  def search_tourbooks
    # look for tourbooks
    find_alll_tourbooks
    @tourbooks = @tourbooks.search(@search_text) if @search_text.present?
    sort_tourbooks

    # look for tours belongs to tourbooks
    find_all_tours
    tourbook_ids = @tourbooks.present? ? @tourbooks.map(&:id) : []
    @tours = @tours.joins(:tourbooks)
                   .where(tourbooks: { id: tourbook_ids })
                   .distinct
    sort_tours
  end

  def find_all_tours
    if @user.present?
      @tours = @user.tours
    else
      @tours = Tour.all
    end
    @tours = @tours.includes(:countries, :taggings, :tags, :user, photos: :country).references(:countries)
  end

  def find_alll_tourbooks
    if @user.present?
      @tourbooks = @user.tourbooks
    else
      @tourbooks = Tourbook.all
    end
    @tourbooks = @tourbooks.includes(:user, :tour_tourbooks, tours: :photos)
  end

  def sort_tours
    if @sort.present?
      @tours = @tours.order(:name) if @sort[:tours] == 'name'
      @tours = @tours.order("tours.tourbooks_count DESC") if @sort[:tours] == 'tourbooks_count'
    end
    @tours = @tours.order(created_at: :desc)
  end

  def sort_tourbooks
    if @sort.present?
      @tourbooks = @tourbooks.order('tourbooks.name ASC') if @sort[:tourbooks] == 'name'
      @tourbooks = @tourbooks.order('tourbooks.tours_count DESC') if @sort[:tourbooks] == 'tours_count'
    end
    @tourbooks = @tourbooks.order('tourbooks.created_at DESC')
  end

  def set_search_params
    @search_text = search_params[:search_text]
    @tab = search_params[:tab] || 'tours'
    @query = search_params[:query]
  end

  def search_params
    @params.permit(:search_text, :tab, query: [:country_id, :tour_type])
  end

  def set_sort_params
    @sort = sort_params[:sort]
  end

  def sort_params
    @params.permit(sort: [:tours, :tourbooks])
  end
end