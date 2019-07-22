# frozen_string_literal: true
module Api::V1
  class ToursController < BaseController
    before_action :set_tour, only: [:show, :update, :destroy]

    # GET /tours
    def index
      @tours = Tour.all
    end

    # GET /tours/1
    def show
    end

    # POST /tours
    def create
      @tour = api_user.tours.build(tour_params)
      if @tour.save
        render json: @tour, status: :created
      else
        render json: {errors: @tour.errors}, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /tours/1
    def update
      if @tour.update(tour_params)
        render json: @tour, status: :ok, location: @tour
      else
        render json: {errors: @tour.errors}, status: :unprocessable_entity
      end
    end

    # DELETE /tours/1
    def destroy
      @tour.destroy
    end

    private

      def set_tour
        @tour = Tour.friendly.find(params[:id])
      end

      def tour_params
        params.require(:tour).permit(:name, :description, :local_id, :google_link, :country_name, :tag_names)
      end
  end
end
