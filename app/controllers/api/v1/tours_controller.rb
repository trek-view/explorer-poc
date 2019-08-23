# frozen_string_literal: true
module Api::V1
  class ToursController < BaseController

    before_action :set_tour, only: %i[show update destroy]

    # GET /api/v1/tours
    def index
      @tours = Tour.includes(:tags, :country, :photos)
      render json: @tours, status: :ok
    end

    # GET /api/v1/tours/:local_id
    def show
      render json: @tour, status: :ok
    end

    # POST /api/v1/tours
    def create
      @tour = api_user.tours.build(tour_params)

      if @tour.save
        render json: @tour, status: :created
      else
        p @tour.errors
        render json: {errors: @tour.errors}, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/tours/:local_id
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

    # DELETE /api/v1/tours/:local_id
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
        @tour = Tour.find_by(local_id: params[:local_id])
      end

      def tour_params
        params.require(:tour).permit(*permitted_params)
      end

      def set_update_params
        params_hash = params.require(:tour).permit(*permitted_params)
        if params_hash[:photos_attributes].present?
          params_hash[:photos_attributes].each do |photo_params|
            photo = @tour.photos.find_by(tourer_photo_id: photo_params[:tourer_photo_id])
            if photo.present?
              photo_params.merge!(id: photo.id)
            else
              params_hash[:photos_attributes].delete(photo_params)
            end
          end
        end

        params_hash
      end

      def permitted_params
        [
            :name,
            :description,
            :local_id,
            :google_link,
            :country_name,
            :tour_type,
            :transport_type,
            :tag_names,
            photos_attributes: [:id,
                                :file_name,
                                :taken_date_time,
                                :latitude,
                                :longitude,
                                :country_code,
                                :elevation_meters,
                                :heading,
                                :street_view_thumbnail_url,
                                :street_view_url,
                                :connection,
                                :connection_distance_km,
                                :tourer_photo_id,
                                :tourer_version]
        ]
      end

  end

end
