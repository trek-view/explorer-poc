# frozen_string_literal: true
module Api::V1
  class PhotosController < BaseController

    before_action :set_tour
    before_action :set_photo, only: %i[show
                                        update
                                        destroy]
    before_action :authorize_tour, only: %i[create
                                        update
                                        destroy]

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
      unless validate_uniqueness_tourer_photo_id
        render json: {
            status: :unprocessable_entity,
            message: "tourer_photo_id should be unique to user_id"
        }, status: :unprocessable_entity
        return
      end

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
      unless validate_uniqueness_tourer_photo_id
        render json: {
            status: :unprocessable_entity,
            message: "tourer_photo_id should be unique to user_id"
        }, status: :unprocessable_entity
        return
      end

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

    def set_viewpoints
      prms = params.require(:viewpoint).permit(*viewpoint_permitted_params)
      photo = Photo.find_by(id: prms[:photo_id])

      unless photo.present?
        render json: {message: 'The photo does not exist', status: :unprocessable_entity}, status: :unprocessable_entity
        return
      end

      if photo.favorited_by?(api_user)
        api_user.unfavorite(photo)
      else
        api_user.favorite(photo)
      end

      render json: {
          viewpoint: {
              count: photo.favoritable_score[:favorite].presence || 0,
              updated_at: DateTime.now.rfc3339,
          }
      }, status: :ok
    end

    def get_viewpoints
      query = search_viewpoint_params

      photos = Photo.where('substring(favoritable_score from 15)::integer > 0')
      photos = photos.where(id: query[:photo_ids]) if query[:photo_ids].present?

      if query[:user_ids].present?
        favorites = Favorite.where(favoritor_id: query[:user_ids]).uniq.pluck(:favoritable_id)
        photos = photos.where(id: favorites)
      end

      photos = photos.order('substring(favoritable_score from 15)::integer DESC')

      photos = photos.page(params[:page] ? params[:page].to_id : 1)

      viewpoints = []
      photos.each do |photo|
        viewpoints << {
            count: photo.favoritable_score[:favorite],
            user_ids: photo.user_favoritors.map {|u| u.id},
            photo_id: photo.id
        }
      end

      render json: {
          viewpoints: viewpoints,
          _metadata: pagination_meta(photos)
      }, status: :ok
    end

    private

      def set_photo
        @photo = Photo.find_by(id: params[:id])
      end

      def photo_params
        prms = params.permit(*permitted_photo_params)
        prms[:filename] = prms[:image].original_filename if prms[:image].present?
        prms[:country] = prms[:address][:country_code] if prms[:address].present? && prms[:address][:country_code].present?
        prms[:tourer_photo_id] = prms[:tourer][:photo_id] if prms[:tourer].present? && prms[:tourer][:photo_id].present?
        prms[:tourer_connection_photo] = prms[:tourer][:connection_photo] if prms[:tourer].present? && prms[:tourer][:connection_photo].present?
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
         tourer: [:photo_id, :connection_photo, :connection_method, :connection_distance_meters, :heading],
         opentrailview: [:photo_id]
        ]
      end

      def authorize_tour
        unless api_user.tours.include?(@tour)
          render json: {message: 'You cannot perform this action.', status: :forbidden}, status: :forbidden
        end
      end

      def find_photos
        set_photo_search_params

        @photos = @tour.photos.includes(:country)

        if @query.present?
          @photos = @photos.joins(:country).where(countries: { code: @query[:countries] }) if @query[:countries].present?
          @photos = @photos.where(photos: {id: @query[:ids]}) if @query[:ids].present?
          @photos = @photos.where("photos.streetview @> hstore(:key, :value)", key: "connections", value: @query[:streetview_connections]) if @query[:streetview_connections].present?
          @photos = @photos.where("photos.tourer_connection_photo IN (?)", @query[:tourer_connection_photos]) if @query[:tourer_connection_photos].present?

          @photos = @photos.order("photos.#{@query[:sort_by]} DESC") if @query[:sort_by].present?
        end

        @photos = @photos.order(taken_at: :desc)
      end

      def set_photo_search_params
        @query = photo_search_params
      end

      def photo_search_params
        params.permit(:streetview_connections, :sort_by, countries: [], ids: [], tourer_connection_photos: [])
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

      def viewpoint_permitted_params
        [:photo_id]
      end

      def search_viewpoint_params
        params.permit(photo_ids: [], user_ids: [])
      end

      def validate_uniqueness_tourer_photo_id
        unless photo_params[:tourer_photo_id].present?
          return true
        end

        photos = Tour.joins(:photos).where(photos: { tourer_photo_id: photo_params[:tourer_photo_id] })
        photos = photos.where(tours: { user_id: api_user.id })
        if photos.any?
          false
        else
          true
        end
      end
  end

end
