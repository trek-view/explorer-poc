# frozen_string_literal: true
module Api::V1
  class ToursController < BaseController
    before_action :set_tour, only: [:show, :update, :destroy]

    # GET /tours
    # GET /tours.json
    def index
      @tours = Tour.all
    end

    # GET /tours/1
    # GET /tours/1.json
    def show
    end

    # POST /tours
    # POST /tours.json
    def create
      @tour = api_user.build_tour(tour_params)
      # @tour = Tour.new(tour_params)

      if @tour.save
        render :show, status: :created, location: @tour
      else
        render json: @tour.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /tours/1
    # PATCH/PUT /tours/1.json
    def update
      if @tour.update(tour_params)
        render :show, status: :ok, location: @tour
      else
        render json: @tour.errors, status: :unprocessable_entity
      end
    end

    # DELETE /tours/1
    # DELETE /tours/1.json
    def destroy
      @tour.destroy
    end

    private


      # Use callbacks to share common setup or constraints between actions.
      def set_tour
        @tour = Tour.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def tour_params
        attributes = (Tour.attribute_names).map(&:to_sym) + [:tag_list, :tag, :tags, { tag_ids: [] }, :tag_ids]

        params.require(:tour).permit(*attributes)
      end
  end
end
