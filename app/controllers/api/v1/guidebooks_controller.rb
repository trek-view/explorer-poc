# frozen_string_literal: true
module Api::V1
  class GuidebooksController < Api::V1::BaseController
    before_action :set_guidebook, only: %i[show update destroy]
    before_action :set_user
    before_action :seperate_guidebook_and_scenes_params, only: %i[create update]
    before_action :set_guidebooks_search_params, only: %i[find_guidebooks]
    before_action :validate_name, only: %i[update]
    before_action :validate_guidebooks, only: %i[create update]

    # GET /api/v1/guidebooks
    def index
      find_guidebooks
      @guidebooks = @guidebooks.page(params[:page] ? params[:page].to_i : 1)
      guidebooks_json = ActiveModelSerializers::SerializableResource.new(
        @guidebooks
      ).as_json
      guidebooks_json['_metadata'] = pagination_meta(@guidebooks)
      render json: guidebooks_json, status: :ok
    end

    # GET /api/v1/guidebooks/:id
    def show
      render json: @guidebook, status: :ok
    end

    # POST /api/v1/guidebooks
    def create
      # Create guidebook
      @guidebook = api_user.guidebooks.build(@guidebook_params)
      return response_unprocessable(@guidebook.errors) unless @guidebook.save

      # Create scenes
      @scenes_params.each do |scene_param|
        scene_param_only = scene_param.except(:tags)
        scene = @guidebook.scenes.build(scene_param_only)
        tag_param = scene_param.delete(:tags)
        return response_unprocessable(scene.errors) unless scene.save

        # if scene_param[:tags] && scene_param.tags.size.positive?
        if tag_param && tag_param.size.positive?
          # scene.tag_list = tag_param
          scene.tags = tag_param.map do |n|
            Tag.where(name: n.strip).first_or_create!
          end
        end
      end
      guidebook_json = ActiveModelSerializers::SerializableResource.new(
        @guidebook
      ).as_json
      render json: guidebook_json, status: :created
    end

    # PATCH/PUT /api/v1/guidebooks/:id
    def update
      return response_unauthorized('You cannot update this guidebook') unless
        api_user.guidebooks.include?(@guidebook)
      return response_unprocessable(@guidebook.errors) unless
        @guidebook.update(@guidebook_params)

      if @scenes_params.size.positive?
        # Delete previous scenes
        @guidebook.scenes.map { |s| s.scenes_tags.delete_all }
        @guidebook.scenes.delete_all

        # Create new scenes with scene params
        @scenes_params.each do |scene_param|
          scene_param_only = scene_param.except(:tags)
          scene = @guidebook.scenes.build(scene_param_only)
          tag_param = scene_param.delete(:tags)
          return response_unprocessable(scene.errors) unless scene.save

          # if scene_param[:tags] && scene_param.tags.size.positive?
          if tag_param && tag_param.size.positive?
            # scene.tag_list = tag_param
            scene.tags = tag_param.map do |n|
              Tag.where(name: n.strip).first_or_create!
            end
          end
        end
        # @scenes_params.each do |scene_params|
        #   scene = @guidebook.scenes.find(scene_params[:id])
        #   return response_unprocessable(scene.errors) unless
        #     scene.update(scene_params)
        # end
      end
      render json: @guidebook, status: :created
    end

    # DELETE /api/v1/guidebooks/:id
    def destroy
      return response_unauthorized('You cannot delete this Guidebook.') unless
        user_guidebook?

      @guidebook.scenes.map { |s| s.scenes_tags.delete_all }
      @guidebook.scenes.delete_all
      @guidebook.destroy
      return response_unprocessable(@guidebook.errors) if @guidebook.errors.any?

      render json: {
        guidebook: { id: @guidebook.id, deleted_at: DateTime.now.rfc3339 }
      }, status: :ok
    end

    # GET /api/v1/users/:user_id/guidebooks
    def user_guidebooks
      return response_forbidden('You can get only your own guidebooks.') if
        api_user == @user

      find_guidebooks
      @guidebooks = @guidebooks.page(params[:page] ? params[:page].to_i : 1)
      guidebooks_json = ActiveModelSerializers::SerializableResource.new(
        @guidebooks
      ).as_json
      guidebooks_json['_metadata'] = pagination_meta(@guidebooks)
      render json: guidebooks_json, status: :ok
    end

    def response_unauthorized(message)
      render json: {
        status: :unauthorized,
        message: message
      }, status: :unauthorized
    end

    def response_forbidden(message)
      render json: {
        status: :forbidden,
        message: message
      }, status: :forbidden
    end

    def response_unprocessable(message)
      render json: {
        status: :unprocessable_entity,
        message: message
      }, status: :unprocessable_entity
    end

    private

    def set_guidebook
      @guidebook = Guidebook.find_by(id: params[:id])
    end

    def guidebook_params
      params.require(:guidebook).permit(
        :id, :name, :description, :category_id, :user_id,
        scenes: [:id, :photo_id, :description, :position, :title, :tags, {tags: []}]
      )
    end

    def seperate_guidebook_and_scenes_params
      puts "========= guidebook_params: #{guidebook_params.inspect}"
      @guidebook_params = guidebook_params.except(:scenes)
      @scenes_params = guidebook_params.delete(:scenes)
    end

    def set_user
      @user = User.find_by(id: params[:user_id])
    end

    def permitted_params
      %i[name description category_id user_id scenes]
    end

    def find_guidebooks
      @guidebooks = @user ? @user.guidebooks : @guidebooks = Guidebook.all
      if @query.present?
        if @query[:sort_by].present?
          order_direction = @query[:sort_by] == 'name' ? 'ASC' : 'DESC'
          @guidebooks = @guidebooks.order(
            "#{@query[:sort_by]} #{order_direction}"
          )
        end
      end
      @guidebooks = @guidebooks.order(updated_at: :desc)
    end

    def set_guidebooks_search_params
      @query = guidebook_search_params
    end

    def guidebook_search_params
      params.permit(:sort_by, scenes: [], ids: [], user_ids: [])
    end

    def pagination_meta(object)
      {
        current_page: object.current_page,
        per_page: Constants::ITEMS_PER_PAGE[:guidebooks],
        next_page: object.next_page,
        prev_page: object.prev_page,
        total_pages: object.total_pages,
        total_count: object.total_count
      }
    end

    def validate_guidebooks
      return unless
        params[:guidebook].present? && guidebook_params[:scenes].empty?

      response_unprocessable('Guidbook IDs are all invalid.')
    end

    def validate_name
      return unless guidebook_params[:name].present?

      response_unprocessable('you cannot change the name of a guidebook.')
    end

    def user_guidebook?
      api_user.guidebooks.include?(@guidebook)
    end
  end
end
