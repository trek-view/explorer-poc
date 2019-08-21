# frozen_string_literal: true
module Api::V1
  class PhotosController < BaseController
    before_action :set_by_tourer_photo_id, only: [:update, :destroy]
    before_action :check_tour

    # GET /tours/:tour_id/photos
    def index
      render json: @tour.photos
    end

    # POST /tours/:tour_id/photos
    def create
      photos = @tour.photos.create(photo_params)

      if photos.all? { |photo| photo.persisted? }
        render json: photos, status: :created
      else
        errors = photos.map do |photo|
          photo.errors.empty? ? {file_name:  photo.file_name, status: :created} : {file_name: photo.file_name, errors: photo.errors.full_messages}
        end
        render json: errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /tours/:tour_id/photos/:tourer_photo_id
    def update
      photos = @tour.update(photo_update_params)
      ##TODO check if record updated
      if photos.all? { |photo| photo.changed? }
        render json: photos, status: :ok
      else
        errors = photos.map do |photo|
          photo.errors.empty? ? {file_name:  photo.file_name, status: :created} : {file_name: photo.file_name, errors: photo.errors.full_messages}
        end
        render json: errors, status: :unprocessable_entity
      end
    end

    # DELETE /tours/:tour_id/photos/:tourer_photo_id
    def destroy
      @photo.destroy
      render json: {message: 'Photo was deleted.'},  head: :no_content, status: :ok
    end

    private

      def set_by_tourer_photo_id
        @photo = Photo.find_by(tourer_photo_id: params[:tourer_photo_id])
      end

      def photo_params
        params.permit(photos: permitted_photo_params).require(:photos)
      end

      def photo_update_params
        params.require(:photo).permit(permitted_photo_params)
      end

      def set_tour
        @tour = Tour.find_by(local_id: params[:tour_id])
      end

      def permitted_photo_params
        [:file_name,
         :taken_date_time,
         :latitude,
         :longitude,
         :elevation_meters,
         :heading,
         :country_code,
         :street_view_url,
         :connection,
         :connection_distance_km,
         :tourer_photo_id]
      end

      def check_tour
        set_tour

        unless api_user.tours.include?(@tour)
          render json: {errors: {authorization: 'You cannot perform this action.'}}
        end
      end
  end
end