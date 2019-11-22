module Api::V1
  class ViewpointsController < BaseController

    def set_viewpoints
      prms = params.require(:viewpoint).permit(*permitted_params)
      photo = Photo.find_by(id: prms[:photo_id])

      unless photo.present?
        render json: {errors: 'The photo does not exist'}, status: :unprocessable_entity
        return
      end

      if photo.favorited_by?(api_user)
        api_user.unfavorite(photo)
      else
        api_user.favorite(photo)
      end

      render json: {
          viewpoint: {
            viewpoint: photo.favoritable_score[:favorite].presence || 0,
            updated_at: DateTime.now.rfc3339
          }
      }, status: :ok
    end

    def get_viewpoints
      query = search_params

      unless query[:photo_id].present?
        render json: {errors: 'The photo does not exist'}, status: :not_found
        return
      end

      photo = Photo.find_by(id: query[:photo_id])

      if photo.nil?
        render json: {errors: 'The photo does not exist'}, status: :not_found
        return
      end

      favoritors = photo.user_favoritors(&:id)

      render json: {
          viewpoint: {
              viewpoint: photo.favoritable_score[:favorite].presence || 0,
              user_ids: favoritors,
          }
      }, status: :ok

    end

    private

    def permitted_params
      [:photo_id]
    end

    def search_params
      params.permit(:photo_id)
    end
  end
end
