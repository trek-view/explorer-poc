# frozen_string_literal: true
class TourBooksController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_tour_book, except: [:index, :new, :create, :user_tour_books]
  before_action :set_user, except: [:index]

  def index
    @tour_books = TourBook.order(created_at: 'DESC')
    @tour_books = @tour_books.page(params[:page])
  end

  def show; end

  def new
    @tour_book = TourBook.new
  end

  def create
    @tour_book = current_user.tour_books.build(tour_book_params)
    authorize @tour_book

    respond_to do |format|
      if @tour_book.save
        add_item
        flash[:success] = 'You TourBook was created!'
        format.html { redirect_to user_tour_books_path }
        format.js
      else
        format.html { render :new }
        format.js
      end
    end
  end

  def edit
    authorize @tour_book
  end

  def update
    authorize @tour_book

    if @tour_book.update(tour_book_params)
      flash[:success] = 'You TourBook was updated!'
      redirect_to user_tour_book_path(@tour_book.user, @tour_book)
    else
      flash[:error] = @tour_book.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    authorize @tour_book

    @tour_book.destroy

    flash[:success] = "TourBook #{@tour_book.name} was destroyed"
    redirect_to user_tour_books_path(current_user)
  end

  def add_item
    authorize @tour_book

    if params[:item_id].present?
      @tour = Tour.find(params[:item_id])

      begin
        @tour_book.tours << @tour
        flash.now[:notice] = "Tour was added to your TourBook #{@tour_book.name}"
      rescue ActiveRecord::RecordInvalid => e
        flash.now[:error] = e.message
      end
    end
  end

  def remove_item
    authorize @tour_book

    if params[:item_id].present?
      @tour = Tour.find(params[:item_id])
      begin
        @tour_book.tours.delete(@tour)
        flash[:success] = "Tour \"#{@tour.name}\" was removed from this TourBook"
      rescue => e
        flash[:error] = e.message
      end
    end
  end

  def user_tour_books
    @tour_books = @user.tour_books
    @tour_books = @tour_books.page(params[:page])
    render 'index'
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

    def set_user
      @user = if params[:user_id]
                User.friendly.find(params[:user_id])
              elsif params[:user]
                User.friendly.find(params[:id])
              else
                current_user
              end

    end

end
