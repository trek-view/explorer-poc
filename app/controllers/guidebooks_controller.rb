class GuidebooksController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_user
  before_action :set_guidebook, except: %i[index new create remove_photo]
  before_action :set_guidebook_for_remove_photo, only: %i[remove_photo]
  before_action :authorize_guidebook, only: %i[
    edit update destroy add_photo remove_photo
  ]
  before_action :set_scenes, only: %i[show edit update destroy]
  before_action :sort_scenes, only: %i[show edit]
  before_action :set_tab, only: %i[new create index show]
  before_action :set_guidebooks_search_params, only: [:index]

  def index
    @guidebooks = @user ? @user.guidebooks : Guidebook.all
    search_guidebooks
    @guidebooks.order(created_at: :desc)
    @guidebooks = @guidebooks.page(params[:page]).per(
      Constants::WEB_ITEMS_PER_PAGE[:guidebooks]
    )
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
        add_photo
        flash[:success] = 'You Guidebook was created!'
        format.html { redirect_to user_guidebooks_path(@user) }
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
      redirect_to user_guidebook_path(@user, @guidebook)
    else
      flash[:error] = @guidebook.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    @guidebook.destroy
    flash[:success] = "Guidebook #{@guidebook.name} was destroyed"
    redirect_to user_guidebook_path(@user)
  end

  def add_photo
    return unless params[:photo_id].present?

    if @guidebook.have_photo(params[:photo_id])
      flash.now[:error] = "The photo already was added in the guidebook."
      return
    end

    begin
      @scene = Scene.create(
        guidebook_id: @guidebook.id,
        description: '',
        position: @guidebook.last_position + 1,
        photo_id: params[:photo_id]
      )
      @photo = Photo.find(params[:photo_id])
      flash.now[:notice] = "
        The photo was added to your Guidebook #{@guidebook.name}
      "
    rescue ActiveRecord::RecordInvalid => e
      flash.now[:error] = e.message
    end
  end

  def remove_photo
    return unless params[:photo_id].present?

    @scene = Scene.find(params[:scene_id])
    begin
      @scene.delete
      flash[:success] = "
        Scene \"#{@scene.description}\" was removed from this Guidebook
      "
    rescue ActiveRecord::RecordNotDestroyed => e
      flash[:error] = e.message
    end
  end

  private

  def set_guidebook
    @guidebook = Guidebook.find(params[:id])
  end

  def set_scenes
    @scenes = @guidebook.scenes.order(:position)
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

  def set_guidebooks_search_params
    @search_text = guidebooks_search_params[:search_text]
  end

  def guidebooks_search_params
    params.permit(:search_text)
  end

  def search_guidebooks
    # @guidebooks = @guidebooks.search(@search_text) if @search_text.present?
    if @search_text.present?
      @guidebooks = @guidebooks.where(
        'lower(name) LIKE ?', '%' + @search_text.downcase + '%'
      ).or(
        @guidebooks.where(
          'lower(description) LIKE ?', '%' + @search_text.downcase + '%'
        )
      )
    end
  end

  def set_guidebook_for_remove_photo
    @guidebook = Guidebook.find(params[:guidebook_id])
  end
end
