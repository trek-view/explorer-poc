# frozen_string_literal: true
module Api::V1
  class TourBooksController < BaseController

    before_action :set_tour_book, only: %i[show update destroy]
    before_action :set_user, only: %i[get_tour_books]

    # GET /api/v1/tour_books
    def index
      @tour_books = TourBook.includes(:tours)
      render json: @tour_books, status: :ok
    end

    # GET /api/v1/tour_books/:id
    def show
      render json: @tour_book, status: :ok
    end

    # POST /api/v1/tour_books
    def create
      @tour_book = api_user.tour_books.build(tour_book_params)

      @tour_book.build_booked_tours(params[:tour_book][:tour_ids])

      if @tour_book.save
        render json: @tour_book, status: :created
      else
        render json: {errors: @tour_book.errors}, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/tour_books/:id
    def update
      if api_user.tour_books.include?(@tour_book)

        tours = Tour.where(tourer_tour_id: params[:tour_book][:tour_ids])
        @tour_book.tours = tours if tours.present?

        if @tour_book.update(tour_book_params)
          render json: @tour_book, status: :ok
        else
          render json: {errors: @tour_book.errors}, status: :unprocessable_entity
        end

      else
        render json: {errors: 'You cannot update this tour'}, status: :unauthorized
      end
    end

    # DELETE /api/v1/tour_books/:id
    def destroy
      if api_user.tour_books.include?(@tour_book)
        @tour_book.destroy
        if @tour_book.errors.any?
          render json: {errors: @tour_book.errors}, status: :unprocessable_entity
        else
          render json: {
              "tour_book": {
                  "id": @tour_book.id,
                  "deleted_at": DateTime.now.rfc3339
              }
          }, status: :ok
        end
      else
        render json: {errors: 'You cannot delete this TourBook'}, status: :unauthorized
      end
    end

    # GET /api/v1/users/:user_id/tour_books
    def get_tour_books
      if api_user == @user
        render json: api_user.tour_books, status: :ok
      else
        render json: {errors: 'You can get only your own tours'}, status: :forbidden
      end
    end

    private

      def set_tour_book
        @tour_book = TourBook.find_by(id: params[:id])
      end

      def tour_book_params
        params.require(:tour_book).permit(*permitted_params)
      end

      def set_user
        @user = User.find_by(id: params[:user_id])
      end

      def permitted_params
        [
            :name,
            :description
        ]
      end

  end

end
