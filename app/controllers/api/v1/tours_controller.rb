# frozen_string_literal: true
module Api::V1
  class ToursController < BaseController
    before_action :set_tour, only: %w(show)
    before_action :set_by_local_id, only: %w(update destroy)

    # GET /tours
    def index
      @tours = Tour.all
    end

    # GET /tours/1
    def show
    end

    # POST /tours
    def create
      @tour = api_user.tours.build(tour_params)

      if @tour.save
        render json: @tour, status: :created
      else
        render json: {errors: @tour.errors}, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /tours/:local_id
    def update
      if api_user.tours.include?(@tour)
        begin
          if @tour.update(set_update_params)
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

    # DELETE /tours/:local_id
    def destroy
      if api_user.tours.include?(@tour)
        @tour.destroy
        if @tour.errors.any?
          render json: {errors: @tour.errors}, status: :unprocessable_entity
        else
          render json: @tour, status: :ok
        end
      else
        render json: {errors: 'You cannot delete this tour'}, status: :unauthorized
      end
    end

    private

      def set_tour
        @tour = Tour.friendly.find(params[:id])
      end

      def set_by_local_id
        @tour = Tour.find_by(local_id: params[:local_id])
      end

      def tour_params
        params.require(:tour).permit(:name,
                                     :description,
                                     :local_id,
                                     :google_link,
                                     :country_name,
                                     :tour_type,
                                     tags_attributes: [:name])
                                     # photos: [:file_name,
                                     #          :taken_date_time,
                                     #          :latitude,
                                     #          :longitude,
                                     #          :elevation_meters,
                                     #          :heading,
                                     #          :country_code,
                                     #          :street_view_url,
                                     #          :connection,
                                     #          :connection_distance_km,
                                     #          :tourer_photo_id])
      end

      def set_update_params
        tour_params.except(:local_id)
      end
  end
end
