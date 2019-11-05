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
      if params[:file].present?
        obj = aws_s3_upload_file

        photo_file_params = {
          file_name: obj.key,
          file_url: obj.public_url,
          thumbnail_url: '',
        }
        photo_file_params = params.permit(*permitted_photo_params).merge(photo_file_params)
        
        photo = @tour.photos.build(photo_file_params)
      else
        photo = @tour.photos.build(photo_params)
      end

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
        params.require(:photo).permit(*permitted_photo_params)
      end

      def set_tour
        @tour = Tour.find_by(id: params[:tour_id])
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
         :tourer_photo_id,
         :plus_code,
         :camera_make,
         :camera_model,
         :main_photo,
         :streetview_id]
      end

      def authorize_tour
        unless api_user.tours.include?(@tour)
          render json: {errors: {authorization: 'You cannot perform this action.'}}, status: :forbidden
        end
      end

      def uuid
        rand(36**8).to_s(36)
      end

      # Upload file to aws s3 bucket
      def aws_s3_upload_file
        key = "#{uuid}_#{params[:file].original_filename}"
        obj = S3_BUCKET.object(key)
        obj.put(body: params[:file])
        obj
      end

  end

end
