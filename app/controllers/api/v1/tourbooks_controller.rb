# frozen_string_literal: true
module Api::V1
  class TourbooksController < BaseController

    before_action :set_tourbook, only: %i[show update destroy]
    before_action :set_user

    # GET /api/v1/tourbooks
    def index
      find_tourbooks
      @tourbooks = @tourbooks.page(params[:page] ? params[:page].to_i : 1)
      tourbooks_json = ActiveModelSerializers::SerializableResource.new(@tourbooks).as_json
      tourbooks_json['_metadata'] = pagination_meta(@tourbooks)
      render json: tourbooks_json, status: :ok
    end

    # GET /api/v1/tourbooks/:id
    def show
      render json: @tourbook, status: :ok
    end

    # POST /api/v1/tourbooks
    def create
      @tourbook = api_user.tourbooks.build(tourbook_params)

      @tourbook.build_tour_tourbooks(tour_id: params[:tourbook][:tour_ids])

      if @tourbook.save
        render json: @tourbook, status: :created
      else
        render json: {
            status: :unprocessable_entity,
            message: @tourbook.errors
        }, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/tourbooks/:id
    def update
      if api_user.tourbooks.include?(@tourbook)

        tours = Tour.where(id: params[:tourbook][:tour_ids])
        @tourbook.tours = tours if tours.present?

        if @tourbook.update(tourbook_params)
          render json: @tourbook, status: :ok
        else
          render json: {
              status: :unprocessable_entity,
              message: @tourbook.errors
          }, status: :unprocessable_entity
        end

      else
        render json: {
            status: :unauthorized,
            message: 'You cannot update this tour'
        }, status: :unauthorized
      end
    end

    # DELETE /api/v1/tourbooks/:id
    def destroy
      if api_user.tourbooks.include?(@tourbook)
        @tourbook.destroy
        if @tourbook.errors.any?
          render json: {
              status: :unprocessable_entity,
              message: @tourbook.errors
          }, status: :unprocessable_entity
        else
          render json: {
              "tourbook": {
                  "id": @tourbook.id,
                  "deleted_at": DateTime.now.rfc3339
              }
          }, status: :ok
        end
      else
        render json: {
            status: :unauthorized,
            message: 'You cannot delete this Tourbook'
        }, status: :unauthorized
      end
    end

    # GET /api/v1/users/:user_id/tourbooks
    def get_tourbooks
      if api_user == @user
        find_tourbooks
        @tourbooks = @tourbooks.page(params[:page] ? params[:page].to_i : 1)
        tourbooks_json = ActiveModelSerializers::SerializableResource.new(@tourbooks).as_json
        tourbooks_json['_metadata'] = pagination_meta(@tourbooks)
        render json: tourbooks_json, status: :ok
      else
        render json: {
            status: :forbidden,
            message: 'You can get only your own tours'
        }, status: :forbidden
      end
    end

    private

      def set_tourbook
        @tourbook = Tourbook.find_by(id: params[:id])
      end

      def tourbook_params
        params.permit(*permitted_params)
      end

      def set_user
        @user = User.find_by(id: params[:user_id])
      end

      def permitted_params
        [
            :name,
            :description,
            tour_ids: []
        ]
      end

      def find_tourbooks
        set_tourbooks_search_params

        if @user
          @tourbooks = @user.tourbooks.includes(:tours)
        else
          @tourbooks = Tourbook.includes(:tours)
        end

        if @query.present?
          @tourbooks = @tourbooks.joins(:tours).where(tours: { id: @query[:tour_ids] }).distinct if @query[:tour_ids].present?
          @tourbooks = @tourbooks.where(tourbooks: { id: @query[:ids] }) if @query[:ids].present?
          @tourbooks = @tourbooks.where(tourbooks: { user_id: @query[:user_ids] }) if @query[:user_ids].present?

          if @query[:sort_by].present?
            if @query[:sort_by] == "name"
              @tourbooks = @tourbooks.order("tourbooks.#{@query[:sort_by]} ASC")
            else
              @tourbooks = @tourbooks.order("tourbooks.#{@query[:sort_by]} DESC")
            end
          end
        end

        @tourbooks = @tourbooks.order("tourbooks.updated_at DESC")
      end

      def set_tourbooks_search_params
        @query = tourbook_search_params
      end

      def tourbook_search_params
        params.permit(:sort_by, tour_ids: [], ids: [], user_ids: [])
      end

      def pagination_meta(object)
        {
            current_page: object.current_page,
            per_page: Constants::ITEMS_PER_PAGE[:tourbooks],
            next_page: object.next_page,
            prev_page: object.prev_page,
            total_pages: object.total_pages,
            total_count: object.total_count
        }
      end

  end

end
