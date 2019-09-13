# frozen_string_literal: true
module Api::V1
  class PhotosController < BaseController

    before_action :set_tour
    before_action :set_by_tourer_photo_id, only: %i[show update destroy]
    before_action :check_tour, only: %i[create update destroy]

    # GET /api/v1/tours/:tourer_tour_id/photos
    def index
      render json: @tour.photos, status: :ok
    end

    # GET /api/v1/tours/:tourer_tour_id/photos/:tourer_photo_id
    def show
      photo = @tour.photos.find_by(tourer_photo_id: params[:tourer_photo_id])
      render json: photo, status: :ok
    end

    # POST /api/v1/tours/:tourer_tour_id/photos
    def create
      photo = @tour.photos.build(photo_params)

      if photo.save
        render json: photo, status: :created
      else
        render json: { errors: photo.errors }, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/tours/:tourer_tour_id/photos/:tourer_photo_id
    def update
      photo = @tour.photos.find_by(tourer_photo_id: params[:tourer_photo_id])

      if photo.update(photo_params)
        render json: { photo: photo } , status: :ok
      else
        render json: { errors: photo.errors }, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/tours/:tourer_tour_id/photos/:tourer_photo_id
    def destroy
      @photo.destroy
      render json: {
          "photo": {
              "id": @photo.id,
              "deleted_at": DateTime.now.rfc3339
          }
      }, head: :no_content, status: :ok
    end

    private

      def set_by_tourer_photo_id
        @photo = Photo.find_by(tourer_photo_id: params[:tourer_photo_id])
      end

      def photo_params
        params.require(:photo).permit(*permitted_photo_params)
      end

      # :tour_id is ID of a tour in a TOURER DB
      def set_tour
        @tour = Tour.find_by(tourer_tour_id: params[:tour_id])
      end

      def permitted_photo_params
        [:file_name,
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
      end

      def check_tour
        unless api_user.tours.include?(@tour)
          render json: {errors: {authorization: 'You cannot perform this action.'}}
        end
      end
  end

end
