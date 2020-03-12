class GuidebooksController < ApplicationController
  include MetaTagsHelper

  before_action :authenticate_user!, except: %i[index show select_scene]
  before_action :set_user
  before_action :set_guidebook, except: %i[index new create remove_photo select_scene]
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

  def show
    @current_scene = @guidebook.scenes[0]
    return unless @current_scene

    @photo = @current_scene ? @current_scene.photo : nil
    @tour = @photo.tour
    photo_og_meta_tag(@photo)
    gon.pannellum_config = guidebook_pannellum_config
    gon.scenes = @guidebook.scenes
    gon.photos = @guidebook.photos
    gon.tour_name = @tour.name
    gon.scene_title = @current_scene.title
    gon.scene_id = @current_scene.id
    gon.scene_description = @current_scene.description
    gon.guidebook_name = @guidebook.name
    gon.guidebook_description = @guidebook.description
    gon.author_name = @guidebook.user.name
    gon.root_url = root_url
  end

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
    @guidebook.scenes.map { |s| s.scenes_tags.delete_all }
    @guidebook.scenes.delete_all
    @guidebook.delete
    flash[:success] = "Guidebook #{@guidebook.name} was destroyed"
    redirect_to user_guidebooks_path(@user)
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

  def select_scene
    @current_scene = Scene.find(params[:scene_id])
    @guidebook = @current_scene.guidebook
    @photo = @current_scene.photo
    @tour = @photo.tour

    photo_og_meta_tag(@photo)
    gon.pannellum_config = guidebook_pannellum_config
    gon.photos = @guidebook.photos
    gon.scenes = @guidebook.scenes
    gon.tour_name = @tour.name
    gon.scene_title = @current_scene.title
    gon.scene_id = @current_scene.id
    gon.scene_description = @current_scene.description
    gon.guidebook_name = @guidebook.name
    gon.guidebook_description = @guidebook.description
    gon.author_name = @guidebook.user.name
    gon.root_url = root_url

    respond_to do |format|
      format.js
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

  def guidebook_pannellum_config
    options = {
      "autoLoad": true,
        "default": {
            "firstScene": @guidebook.scenes[0].id,
            "title": @current_scene.description,
            "author": @guidebook.user.name,
            "authorURL": photo_path(@photo),
            "sceneFadeDuration": 0
        },
        "scenes": {}
    }

    @guidebook.scenes.each do |scene|
      photo = scene.photo
      next unless photo.tourer["connections"]
      begin
        connections = JSON.parse(photo.tourer["connections"])
        hot_spots = []
        connections&.keys&.each do |key|
          hot_photo = photo.tour.photos.select{ |connected_photo| connected_photo.tourer_photo_id == connections[key]["photo_id"] }.first
          if hot_photo
            hot_spots << {
                "type": "scene",
                "pitch": connections[key]["pitch_degrees"].to_f,
                "yaw": connections[key]["adjusted_heading_degrees"].to_f,
                "text": hot_photo.tourer_photo_id,
                "sceneId": scene.id #hot_photo.tourer_photo_id
            }
          end
        end
      rescue => exception
        puts "=== exception: #{exception.inspect}"
      end

      options[:scenes][scene.id] = {
        "title": scene.description,
        "author": @guidebook.user.name,
        "authorURL": photo_path(photo),
        "type": "equirectangular",
        "panorama": photo.image_path,
        "hotSpots": hot_spots
      }
    end

    options
  end
end
