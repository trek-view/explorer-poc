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
      find_photos
      @photos = @photos.page(params[:page] ? params[:page].to_id : 1)
      photos_json = ActiveModelSerializers::SerializableResource.new(@photos).as_json
      photos_json[:photos] = photos_json[:photos].map do |photo|
        photo['user_id'] = @tour.user_id
        photo
      end
      photos_json['_metadata'] = pagination_meta(@photos)
      render json: photos_json, status: :ok
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
        render json: {
            status: :unprocessable_entity,
            message: photo.errors
        }, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/tours/:tour_id/photos/:id
    def update
      photo = @tour.photos.find_by(id: params[:id])

      if photo.update(photo_params)
        render json: { photo: photo } , status: :ok
      else
        render json: {
            status: :unprocessable_entity,
            message: photo.errors
        }, status: :unprocessable_entity
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

      def find_photos
        set_photo_search_params

        @photos = @tour.photos.includes(:country)

        if @query.present?
          @photos = @photos.joins(:country).where(countries: { code: @query[:countries] }) if @query[:countries].present?
          @photos = @photos.where(photos: {id: @query[:ids]}) if @query[:ids].present?
          @photos = @photos.order("photos.#{@query[:sort_by]} DESC") if @query[:sort_by].present?
        end

        @photos = @photos.order(taken_at: :desc)
      end

      def set_photo_search_params
        @query = photo_search_params
      end

      def photo_search_params
        params.permit(:sort_by, :user_id, countries: [], ids: [])
      end

      def pagination_meta(object)
        {
          current_page: object.current_page,
          per_page: Constants::ITEMS_PER_PAGE[:photos],
          next_page: object.next_page,
          prev_page: object.prev_page,
          total_pages: object.total_pages,
          total_count: object.total_count
        }
      end
  end

end
