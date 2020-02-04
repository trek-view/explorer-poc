# frozen_string_literal: true
module Api::V1
  class GuidebooksController < Api::V1::BaseController

    before_action :set_guidebook, only: %i[show update destroy]
    before_action :set_user

    # GET /api/v1/guidebooks
    def index
      find_guidebooks
      @guidebooks = @guidebooks.page(params[:page] ? params[:page].to_i : 1)
      guidebooks_json = ActiveModelSerializers::SerializableResource
        .new(@guidebooks).as_json
      guidebooks_json['_metadata'] = pagination_meta(@guidebooks)
      render json: guidebooks_json, status: :ok
    end

    # GET /api/v1/guidebooks/:id
    def show
      render json: @guidebook, status: :ok
    end

    # POST /api/v1/guidebooks
    def create
      validate_guidebooks and return
      @guidebook_params = guidebook_params.except(:scenes)
      @scenes_params = guidebook_params.delete(:scenes)

      p1 = guidebook_params.except(:scenes)
      # Create guidebook
      @guidebook = api_user.guidebooks.build(@guidebook_params)
      puts "===== @guidebook: #{@guidebook.inspect}"
      if @guidebook.save
        # Create scenes
        @scenes_params.each do |scene_params|
          scene = @guidebook.guidebooks_photos.build(scene_params)
          scene.save
        end

        guidebook_json = ActiveModelSerializers::SerializableResource
          .new(@guidebook).as_json
        render json: guidebook_json, status: :created
      else
        render json: {
            status: :unprocessable_entity,
            message: @guidebook.errors
        }, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/guidebooks/:id
    def update
      # validate_name and return
      validate_guidebooks and return

      if api_user.guidebooks.include?(@guidebook)

        guidebooks = Guidebook.where(id: params[:scenes])
        @guidebook.guidebooks = guidebooks if guidebooks.present?

        if @guidebook.update(guidebook_params)
          render json: @guidebook, status: :ok
        else
          render json: {
              status: :unprocessable_entity,
              message: @guidebook.errors
          }, status: :unprocessable_entity
        end

      else
        render json: {
            status: :unauthorized,
            message: 'You cannot update this guidebook'
        }, status: :unauthorized
      end
    end

    # DELETE /api/v1/guidebooks/:id
    def destroy
      if api_user.guidebooks.include?(@guidebook)
        @guidebook.destroy
        if @guidebook.errors.any?
          render json: {
              status: :unprocessable_entity,
              message: @guidebook.errors
          }, status: :unprocessable_entity
        else
          render json: {
              "guidebook": {
                  "id": @guidebook.id,
                  "deleted_at": DateTime.now.rfc3339
              }
          }, status: :ok
        end
      else
        render json: {
            status: :unauthorized,
            message: 'You cannot delete this Guidebook'
        }, status: :unauthorized
      end
    end

    # GET /api/v1/users/:user_id/guidebooks
    def get_guidebooks
      if api_user == @user
        find_guidebooks
        @guidebooks = @guidebooks.page(params[:page] ? params[:page].to_i : 1)
        guidebooks_json = ActiveModelSerializers::SerializableResource.new(@guidebooks).as_json
        guidebooks_json['_metadata'] = pagination_meta(@guidebooks)
        render json: guidebooks_json, status: :ok
      else
        render json: {
            status: :forbidden,
            message: 'You can get only your own guidebooks'
        }, status: :forbidden
      end
    end

    private

      def set_guidebook
        @guidebook = Guidebook.find_by(id: params[:id])
      end

      def guidebook_params
        params.require(:guidebook).permit(
          :id, :name, :description, :category_id, :user_id,
          scenes: [:id, :photo_id, :description, :position]
        )
      end

      def set_user
        @user = User.find_by(id: params[:user_id])
      end

      def permitted_params
        [
          :name,
          :description,
          :category_id,
          :user_id,
          :scenes
        ]
      end

      def find_guidebooks
        set_guidebooks_search_params

        if @user
          @guidebooks = @user.guidebooks
        else
          @guidebooks = Guidebook.all()
        end

        if @query.present?
          # @guidebooks = @guidebooks.joins(:guidebooks).where(guidebooks: { id: @query[:scenes] }).distinct if @query[:scenes].present?
          # @guidebooks = @guidebooks.where(guidebooks: { id: @query[:ids] }) if @query[:ids].present?
          # @guidebooks = @guidebooks.where(guidebooks: { user_id: @query[:user_ids] }) if @query[:user_ids].present?

          if @query[:sort_by].present?
            if @query[:sort_by] == "name"
              @guidebooks = @guidebooks.order("guidebooks.#{@query[:sort_by]} ASC")
            else
              @guidebooks = @guidebooks.order("guidebooks.#{@query[:sort_by]} DESC")
            end
          end
        end

        @guidebooks = @guidebooks.order("guidebooks.updated_at DESC")
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
        if params[:guidebook].present? && guidebook_params[:scenes].empty?
          render json: {
              status: :unprocessable_entity,
              message: 'Guidbook IDs are all invalid'
          }, status: :unprocessable_entity
        end
      end
  end
end
