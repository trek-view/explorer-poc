class TourBooksController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_tour_book, except: [:index, :new, :create]
  before_action :set_user

  def index
    @tour_books = @user.tour_books
    @tour_books = @tour_books.page(params[:page])
  end

  def show

  end

  def new
    @tour_book = TourBook.new
  end

  def create
    @tour_book = @user.tour_books.build(tour_book_params)

    authorize @tour_book
    if @tour_book.save
      flash[:success] = 'You TourBook was created!'
      redirect_to user_tour_books_path
    else
      flash[:error] = @tour_book.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    authorize @tour_book
  end

  def update
    authorize @tour_book
  end

  def destroy
    authorize @tour_book
  end

  private

    def set_tour_book
      @tour_book = TourBook.friendly.find(params[:id])
    end

    def tour_book_params
      params.require(:tour_book).permit(*permitted_params)
    end

    def permitted_params
      [
          :name,
          :description
      ]
    end

end
