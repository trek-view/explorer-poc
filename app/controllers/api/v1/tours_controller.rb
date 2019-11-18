# frozen_string_literal: true
module Api::V1
  class ToursController < BaseController

    before_action :set_tour, only: %i[show update destroy]
    before_action :set_user, only: %i[get_tours]

    # GET /api/v1/tours
    def index
      find_tours
      @tours = @tours.page(params[:page] ? params[:page].to_i : 1)
      tours_json = ActiveModelSerializers::SerializableResource.new(@tours).as_json
      render json: {tours: tours_json, _metadata: pagination_meta(@tours) }
    end

    # GET /api/v1/tours/:id
    def show
      render json: @tour, status: :ok
    end

    # POST /api/v1/tours
    def create
      @tour = api_user.tours.build(tour_params)

      if @tour.save
        render json: @tour, status: :created
      else
        render json: {errors: @tour.errors}, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/tours/:id
    def update
      if api_user.tours.include?(@tour)
        begin
          if @tour.update(tour_params)
            render json: @tour, status: :ok
          else
            render json: {errors: @tour.errors}, status: :unprocessable_entity
          end
        rescue ArgumentError => e
          @tour.errors.add(:tour_type, e)
          render json: {errors: @tour.errors}, status: :unprocessable_entity
        end
      else
        render json: {errors: 'You cannot update this tour'}, status: :unauthorized
      end
    end

    # DELETE /api/v1/tours/:id
    def destroy
      if api_user.tours.include?(@tour)
        @tour.destroy
        if @tour.errors.any?
          render json: {errors: @tour.errors}, status: :unprocessable_entity
        else
          render json: {
                        "tour": {
                                  "id": @tour.id,
                                  "deleted_at": DateTime.now.rfc3339
                                }
                        }, status: :ok
        end
      else
        render json: {errors: 'You cannot delete this tour'}, status: :unauthorized
      end
    end

    # GET /api/v1/users/:user_id/tours
    def get_tours
      if api_user == @user
        render json: api_user.tours, status: :ok
      else
        render json: {errors: 'You can get only your own tours'}, status: :forbidden
      end
    end

    private

    def set_tour
      @tour = Tour.find_by(id: params[:id])
    end

    def tour_params
      parameters = params.require(:tour).permit(*permitted_params)
      parameters[:tag_names] = parameters[:tags] if parameters[:tags]
      parameters.except(:tags)
    end

    def set_user
      @user = User.find_by(id: params[:user_id])
    end

    def permitted_params
      [
          :name,
          :description,
          :tourer_tour_id,
          :tourer_version,
          :tour_type,
          :transport_type,
          :tags
      ]
    end

    def list_tours
      @tours.map do |tour|
        {
            id: tour[:id],
            name: tour[:name],
            description: tour[:description],
            tour_type: tour[:tour_type],
            transport_type: tour[:transport_type],
            tourer_version: tour[:tourer_version],
            tourer_tour_id: tour[:tourer_tour_id],
            created_at: tour[:created_at],
            user_id: tour[:user_id]
        }
      end
    end

    def pagination_meta(object)
      {
        current_page: object.current_page,
        per_page: Constants::ITEMS_PER_PAGE[:tours],
        next_page: object.next_page,
        prev_page: object.prev_page,
        total_pages: object.total_pages,
        total_count: object.total_count
      }
    end

    def find_tours
      set_tours_search_params

      @tours = Tour.includes(:countries, :tags, :user).order(updated_at: :desc)

      if @query.present?
        @tours = @tours.reorder("#{@query[:sort_by]} DESC") if @query[:sort_by].present?
        @tours = @tours.where(user_id: @query['user_id']) if @query['user_id'].present?
        @tours = @tours.where(id: @query['id']) if @query['id'].present?
        @tours = @tours.joins(:countries).where('lower(countries.name) like ?', "%#{@query['country'].downcase}%" ) if @query['country'].present?
        @tours = @tours.search(@query['tag']) if @query['tag'].present?
      end
    end

    def set_tours_search_params
      @query = tour_search_params
    end

    def tour_search_params
      params.permit(:country, :tag, :user_id, :id, :tag, :sort_by)
    end

  end

end
