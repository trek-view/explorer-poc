class ToursFinder
  def initialize(params, user = nil)
    @params = params
    @user = user
  end

  def search
    find_tours
    find_tourbooks
    @tours = @tours.page(@params[:page])
    @tourbooks = @tourbooks.page(@params[:page])
    {
        tours: @tours,
        tourbooks: @tourbooks,
        sort: @sort,
        query: @query,
        search_text: @search_text
    }
  end

  private

  def find_tours
    set_search_params
    set_sort_params

    if @user.present?
      @tours = @user.tours
    else
      @tours = Tour.all
    end
    @tours = @tours.includes(:countries, :taggings, :tags, :user, photos: :country).references(:countries)

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
    if @user.present?
      @tourbooks = @user.tourbooks
    else
      @tourbooks = Tourbook.all
    end

    tour_ids = @tours.present? ? @tours.map(&:id) : []
    @tourbooks = @tourbooks.includes(:user, :tour_tourbooks, tours: :photos)
                     .references(:tours)
                     .where(tours: { id: tour_ids })
                     .distinct

    if @sort.present?
      @tourbooks = @tourbooks.order('tourbooks.name ASC') if @sort[:tourbooks] == 'name'
      @tourbooks = @tourbooks.order('tourbooks.tours_count DESC') if @sort[:tourbooks] == 'tours_count'
    end
    @tourbooks = @tourbooks.order('tourbooks.created_at DESC')
  end

  def set_search_params
    @search_text = search_params[:search_text]
    @query = search_params[:query]
  end

  def search_params
    @params.permit(:search_text, query: [:country_id, :tour_type])
  end

  def set_sort_params
    @sort = sort_params[:sort]
  end

  def sort_params
    @params.permit(sort: [:tours, :tourbooks])
  end
end