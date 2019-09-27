# frozen_string_literal: true
module Api::V1
  class ToursController < BaseController

    before_action :set_tour, only: %i[show update destroy]

    # GET /api/v1/tours
    def index
      @tours = Tour.includes(:tags, :countries, :photos)
      render json: @tours, status: :ok
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

    # GET /api/v1/user_tours
    def user_tours
      render json: api_user.tours, status: :ok
    end

    private

      def set_tour
        @tour = Tour.find_by(id: params[:id])
      end

      def tour_params
        params.require(:tour).permit(*permitted_params)
      end

      def permitted_params
        [
            :name,
            :description,
            :tourer_tour_id,
            :tourer_version,
            :countries,
            :tour_type,
            :transport_type,
            :tag_names,
            photos_attributes: [:id,
                                :file_name,
                                :taken_date_time,
                                :latitude,
                                :longitude,
                                :country,
                                :elevation_meters,
                                :heading,
                                :street_view_thumbnail_url,
                                :street_view_url,
                                :connection,
                                :connection_distance_km,
                                :tourer_photo_id]
        ]
      end

  end

end
