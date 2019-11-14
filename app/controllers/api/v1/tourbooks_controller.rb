# frozen_string_literal: true
module Api::V1
  class TourbooksController < BaseController

    before_action :set_tourbook, only: %i[show update destroy]
    before_action :set_user, only: %i[get_tourbooks]

    # GET /api/v1/tourbooks
    def index
      @tourbooks = Tourbook.includes(:tours)
      render json: @tourbooks, status: :ok
    end

    # GET /api/v1/tourbooks/:id
    def show
      render json: @tourbook, status: :ok
    end

    # POST /api/v1/tourbooks
    def create
      @tourbook = api_user.tourbooks.build(tourbook_params)

      @tourbook.build_booked_tours(params[:tourbook][:tour_ids])

      if @tourbook.save
        render json: @tourbook, status: :created
      else
        render json: {errors: @tourbook.errors}, status: :unprocessable_entity
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
          render json: {errors: @tourbook.errors}, status: :unprocessable_entity
        end

      else
        render json: {errors: 'You cannot update this tour'}, status: :unauthorized
      end
    end

    # DELETE /api/v1/tourbooks/:id
    def destroy
      if api_user.tourbooks.include?(@tourbook)
        @tourbook.destroy
        if @tourbook.errors.any?
          render json: {errors: @tourbook.errors}, status: :unprocessable_entity
        else
          render json: {
              "tourbook": {
                  "id": @tourbook.id,
                  "deleted_at": DateTime.now.rfc3339
              }
          }, status: :ok
        end
      else
        render json: {errors: 'You cannot delete this Tourbook'}, status: :unauthorized
      end
    end

    # GET /api/v1/users/:user_id/tourbooks
    def get_tourbooks
      if api_user == @user
        render json: api_user.tourbooks, status: :ok
      else
        render json: {errors: 'You can get only your own tours'}, status: :forbidden
      end
    end

    private

      def set_tourbook
        @tourbook = Tourbook.find_by(id: params[:id])
      end

      def tourbook_params
        params.require(:tourbook).permit(*permitted_params)
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

  end

end
