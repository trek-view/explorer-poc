# frozen_string_literal: true
module Api::V1
  class PhotosController < BaseController

    before_action :set_tour
    before_action :set_photo, only: %i[show
                                        update
                                        destroy
                                        set_photo_view_point
                                        unset_photo_view_point]
    before_action :authorize_tour, only: %i[create
                                        update
                                        destroy
                                        set_photo_view_point
                                        unset_photo_view_point]

    # GET /api/v1/tours/:tour_id/photos
    def index
      render json: @tour.photos, status: :ok
    end

    # GET /api/v1/tours/:tour_id/photos/:id
    def show
      render json: @photo, status: :ok
    end

    # POST /api/v1/tours/:tour_id/photos
    def create
      photo = @tour.photos.build(photo_params)
      photo.image = params[:image]

      if photo.save
        render json: photo, status: :created
      else
        render json: { errors: photo.errors }, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/tours/:tour_id/photos/:id
    def update
      photo = @tour.photos.find_by(id: params[:id])

      if photo.update(photo_params)
        render json: { photo: photo } , status: :ok
      else
        render json: { errors: photo.errors }, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/tours/:tour_id/photos/:id
    def destroy
      @photo.destroy
      render json: {
          "photo": {
              "id": @photo.id,
              "deleted_at": DateTime.now.rfc3339
          }
      }, head: :no_content, status: :ok
    end

    # POST /api/v1/tours/:tour_id/photos/:id/set_photo_view_point
    def set_photo_view_point
      if @photo.present?
        @photo.set_a_view_point(api_user, @photo.tour)
        render json: { photo: @photo } , status: :ok
      else
        render json: { errors: 'Cannot viewpoint this photo' }, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/tours/:tour_id/photos/:id/unset_photo_view_point
    def unset_photo_view_point
      if @photo.present?
        @photo.clear_view_point(api_user)
        render json: { photo: @photo } , status: :ok
      else
        render json: { errors: 'Cannot unset viewpoint for this photo.' }, status: :unprocessable_entity
      end
    end

    private

      def set_photo
        @photo = Photo.find_by(id: params[:id])
      end

      def photo_params
        prms = params.permit(*permitted_photo_params)
        prms[:country] = prms[:address][:country_code]
        prms[:tourer_photo_id] = prms[:tourer][:photo_id]
        prms
      end

      def set_tour
        @tour = Tour.find_by(id: params[:tour_id])
      end

      def permitted_photo_params
        [:image,
         :taken_at,
         :latitude,
         :longitude,
         :elevation_meters,
         :camera_make,
         :camera_model,
         address: [:cafe, :road, :suburb, :county, :region, :state, :postcode, :country, :country_code],
         google: [:plus_code_global_code, :plus_code_compound_code],
         streetview: [:photo_id, :capture_time, :share_link, :download_url, :thumbnail_url, :lat, :lon, :altitude, :heading, :pitch, :roll, :level, :connections],
         tourer: [:photo_id, :connection_photo, :connection_method, :connection_distance_meters, :heading]
        ]
      end

      def authorize_tour
        unless api_user.tours.include?(@tour)
          render json: {errors: {authorization: 'You cannot perform this action.'}}, status: :forbidden
        end
      end
  end

end
