class GuidebooksController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_user
  before_action :set_guidebook, except: %i[new create user_guidebooks]
  before_action :authorize_guidebook, only: %i[
    show edit update destroy add_item remove_item
  ]
  before_action :set_scenes, only: %i[show edit update destroy]
  before_action :sort_scenes, only: %i[show edit]
  before_action :set_tab, only: %i[new create user_guidebooks show index]

  def index
    user_guidebooks
  end

  def show; end

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
      else
        format.html { render :new }
      end
      format.js
    end
  end

  def edit; end

  def update
    if @guidebook.update(guidebook_params)
      flash[:success] = 'Your guidebook was updated!'
      redirect_to user_guidebook_path(@guidebook.user, @guidebook)
    else
      flash[:error] = @guidebook.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    @guidebook.destroy
    flash[:success] = "Guidebook #{@guidebook.name} was destroyed"
    redirect_to user_guidebooks_path(current_user)
  end

  def add_item
    return unless params[:item_id].present?

    @scene = Scene.find(params[:item_id])
    begin
      @guidebook.scenes << @scene
      flash.now[:notice] = "
        Scene was added to your Guidebook #{@guidebook.name}
      "
    rescue ActiveRecord::RecordInvalid => e
      flash.now[:error] = e.message
    end
  end

  def remove_item
    return unless params[:item_id].present?

    @scene = Scene.find(params[:item_id])
    begin
      @guidebook.scenes.delete(@scene)
      flash[:success] = "
        Scene \"#{@scene.name}\" was removed from this Guidebook
      "
    rescue ActiveRecord::RecordNotDestroyed => e
      flash[:error] = e.message
    end
  end

  def user_guidebooks
    @guidebooks = @user.guidebooks
    @guidebooks = @guidebooks.page(params[:page]).per(
      Constants::WEB_ITEMS_PER_PAGE[:guidebooks]
    )
    render 'index'
  end

  private

  def set_guidebook
    @guidebook = Guidebook.find(params[:id])
  end

  def set_scenes
    @scenes = @guidebook.scenes
  end

  def set_tab
    @tab = 'guidebooks'
  end

  def authorize_guidebook
    authorize @guidebook
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
    params.permit(sort: [:scenes])
  end

  def sort_scenes
    set_sort_params

    if @sort.present?
      @scenes = @scenes.order(:name) if @sort[:name] == 'name'
      @scenes = @scenes.order(:position) if @sort[:scenes] == 'position'
      @scenes = @scenes.order(positions_count: :desc) if
        @sort[:scenes] == 'scenes_count'
    end
    @scenes = @scenes.order(:position)
  end
end
