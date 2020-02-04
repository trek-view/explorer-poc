class GuidebooksController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_guidebook, except: [:new, :create, :user_guidebooks, :show]
  before_action :set_user
  before_action :set_tab, only: %i[new create user_guidebooks show index]

  def index
    user_guidebooks
  end

  def show
    set_sort_params

    @guidebook = Guidebook.find(params[:id])
    @scenes = @guidebook.scenes

    if @sort.present?
      @scenes = @scenes.order(:name) if @sort[:name] == 'name'
      @scenes = @scenes.order(position: :desc) if @sort[:scenes] == 'position'
      @scenes = @scenes.order(positions_count: :desc) if
        @sort[:scenes] == 'scenes_count'
    end
    @scenes = @scenes.order(created_at: :desc)
  end

  def new
    @guidebook = Guidebook.new
  end

  def create
    @guidebook = current_user.guidebooks.build(guidebook_params)
    authorize @guidebook

    respond_to do |format|
      if @guidebook.save
        add_item
        flash[:success] = 'You Guidebook was created!'
        format.html { redirect_to user_guidebooks_path }
        format.js
      else
        format.html { render :new }
        format.js
      end
    end
  end

  def edit
    authorize @guidebook
  end

  def update
    authorize @guidebook

    if @guidebook.update(guidebook_params)
      flash[:success] = 'You Guidebook was updated!'
      redirect_to user_guidebook_path(@guidebook.user, @guidebook)
    else
      flash[:error] = @guidebook.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    authorize @guidebook

    @guidebook.destroy

    flash[:success] = "Guidebook #{@guidebook.name} was destroyed"
    redirect_to user_guidebooks_path(current_user)
  end

  def add_item
    authorize @guidebook

    if params[:item_id].present?
      @tour = Tour.find(params[:item_id])

      begin
        @guidebook.tours << @tour
        flash.now[:notice] = "Tour was added to your Guidebook #{@guidebook.name}"
      rescue ActiveRecord::RecordInvalid => e
        flash.now[:error] = e.message
      end
    end
  end

  def remove_item
    authorize @guidebook

    if params[:item_id].present?
      @tour = Tour.find(params[:item_id])
      begin
        @guidebook.tours.delete(@tour)
        flash[:success] = "Tour \"#{@tour.name}\" was removed from this Guidebook"
      rescue => e
        flash[:error] = e.message
      end
    end
  end

  def user_guidebooks
    @guidebooks = @user.guidebooks
    @guidebooks = @guidebooks.page(params[:page]).per(Constants::WEB_ITEMS_PER_PAGE[:guidebooks])
    render 'index'
  end

  private

  def set_guidebook
    @guidebook = Guidebook.find(params[:id])
  end

  def guidebook_params
    params.require(:guidebook).permit(*permitted_params)
  end

  def permitted_params
    %i[name description category_id user_id scenes]
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

  def set_sort_params
    @sort = sort_params[:sort]
  end

  def sort_params
    params.permit(sort: [:tours])
  end

  def set_tab
    @tab = 'guidebooks'
  end
end
