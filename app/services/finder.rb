class Finder
  def initialize(params, user = nil)
    @params = params
    @user = user
  end

  def search
    set_search_params
    set_sort_params

    search_tours
    @tours = @tours.page(@params[:tour_pagina]).per(
      Constants::WEB_ITEMS_PER_PAGE[:tours]
    )

    search_tourbooks
    @tourbooks = @tourbooks.page(@params[:tourbook_pagina]).per(
      Constants::WEB_ITEMS_PER_PAGE[:tourbooks]
    )

    search_guidebooks
    @guidebooks = @guidebooks.page(@params[:guidebook_pagina]).per(
      Constants::WEB_ITEMS_PER_PAGE[:guidebooks]
    )

    {
        tours: @tours,
        tourbooks: @tourbooks,
        guidebooks: @guidebooks,
        sort: @sort,
        query: @query,
        search_text: @search_text,
        tab: @tab
    }
  end

  private

  def search_tours_and_tourbooks
    # look for tours
    find_all_tours
    find_alll_tourbooks

    if @query.present?
      if @query['country_id'].present?
        tour_ids = Photo.where(country_id: @query['country_id']).pluck(:tour_id).uniq
        @tours = @tours.where(id: tour_ids)
      end
      @tours = @tours.where(tour_type: @query['tour_type']) if @query['tour_type'].present?
      @tours = @tours.where(transport_type: @query['transport_type']) if @query['transport_type'].present?
    end

    tourbook_ids = []

    if @search_text.present?
      @tours = @tours.search(@search_text)
      tourbook_ids = @tourbooks.search(@search_text).pluck(:id).uniq
    end

    sort_tours

    # look for tourbooks including tours
    tour_ids = @tours.present? ? @tours.map(&:id) : []
    if tour_ids.present?
      tourbook_ids += TourTourbook.where(tour_id: tour_ids).pluck(
        :tourbook_id
      ).uniq
    end

    @tourbooks = Tourbook.where(id: tourbook_ids.uniq)

    sort_tourbooks
  end

  def search_tours
    find_all_tours
    @tours = @tours.search(@search_text) if @search_text.present?
    sort_tours
  end

  def search_tourbooks
    find_alll_tourbooks
    @tourbooks = @tourbooks.search(@search_text) if @search_text.present?
    sort_tourbooks
  end

  def find_all_tours
    @tours = @user.present? ? @user.tours : Tour.all
  end

  def find_alll_tourbooks
    @tourbooks = @user.present? ? @user.tourbooks : @tourbooks = Tourbook.all
  end

  def sort_tours
    if @sort.present?
      @tours = @tours.order(:name) if @sort[:tours] == 'name'
      @tours = @tours.order("tours.tourbooks_count DESC") if @sort[:tours] == 'tourbooks_count'
      @tours = @tours.order("tours.photos_count DESC") if @sort[:tours] == 'photos_count'
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

  ### Guidebooks
  def find_alll_guidebooks
    return @guidebooks = @user.guidebooks if @user.present?

    @guidebooks = Guidebook.all
  end

  def find_all_scenes
    @scenes = @guidebooks.scenes
  end

  def sort_guidebooks
    if @sort.present?
      @guidebooks = @guidebooks.order(name: :asc) if
        @sort[:guidebooks] == 'name'
      @guidebooks = @guidebooks.order('guidebooks.scenes_count DESC') if
        @sort[:guidebooks] == 'scenes_count'
    end
    @guidebooks = @guidebooks.order(created_at: :desc)
  end

  def search_guidebooks
    # look for guidebooks
    find_alll_guidebooks
    @guidebooks = @guidebooks.search(@search_text) if @search_text.present?
    sort_guidebooks

    # look for scenes belongs to guidebooks
    # # find_all_scenes
    # guidebook_ids = @guidebooks.present? ? @guidebooks.map(&:id) : []
    # if guidebook_ids.present?
    #   @scenes = @guidebooks.scenes.pluck(:id).uniq guidebook_ids.present?
    # end
    # sort_scenes
  end

  def set_search_params
    @search_text = search_params[:search_text]
    @tab = search_params[:tab] || 'tours'
    @query = search_params[:query]
  end

  def search_params
    @params.permit(:search_text, :tab, query: %i[country_id tour_type transport_type])
  end

  def set_sort_params
    @sort = sort_params[:sort]
  end

  def sort_params
    @params.permit(sort: %i[tours tourbooks guidebooks])
  end
end
