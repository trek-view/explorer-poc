# frozen_string_literal: true
class TourbooksController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_tourbook, except: [:index, :new, :create, :user_tourbooks, :show]
  before_action :set_user, except: [:index]

  def index
    @tourbooks = Tourbook.includes(:user, tours: :photos).order(created_at: 'DESC')
    @tourbooks = @tourbooks.page(params[:page])
  end

  def show
    @tourbook = Tourbook.includes(tours: [:photos, :countries, :tags, :user]).friendly.find(params[:id])
  end

  def new
    @tourbook = Tourbook.new
  end

  def create
    @tourbook = current_user.tourbooks.build(tourbook_params)
    authorize @tourbook

    respond_to do |format|
      if @tourbook.save
        add_item
        flash[:success] = 'You TourBook was created!'
        format.html { redirect_to user_tourbooks_path }
        format.js
      else
        format.html { render :new }
        format.js
      end
    end
  end

  def edit
    authorize @tourbook
  end

  def update
    authorize @tourbook

    if @tourbook.update(tourbook_params)
      flash[:success] = 'You TourBook was updated!'
      redirect_to user_tourbook_path(@tourbook.user, @tourbook)
    else
      flash[:error] = @tourbook.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    authorize @tourbook

    @tourbook.destroy

    flash[:success] = "TourBook #{@tourbook.name} was destroyed"
    redirect_to user_tourbooks_path(current_user)
  end

  def add_item
    authorize @tourbook

    if params[:item_id].present?
      @tour = Tour.find(params[:item_id])

      begin
        @tourbook.tours << @tour
        flash.now[:notice] = "Tour was added to your TourBook #{@tourbook.name}"
      rescue ActiveRecord::RecordInvalid => e
        flash.now[:error] = e.message
      end
    end
  end

  def remove_item
    authorize @tourbook

    if params[:item_id].present?
      @tour = Tour.find(params[:item_id])
      begin
        @tourbook.tours.delete(@tour)
        flash[:success] = "Tour \"#{@tour.name}\" was removed from this TourBook"
      rescue => e
        flash[:error] = e.message
      end
    end
  end

  def user_tourbooks
    @tourbooks = @user.tourbooks.includes(tours: [:photos])
    @tourbooks = @tourbooks.page(params[:page])
    render 'index'
  end

  private

  def set_tourbook
    @tourbook = Tourbook.friendly.find(params[:id])
  end

  def tourbook_params
    params.require(:tourbook).permit(*permitted_params)
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