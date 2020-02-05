class ScenesController < ApplicationController
  before_action :set_user_and_guidebook, except: [:select_scene_photo]
  before_action :set_scene, only: %i[show edit update destroy]

  def index
    @scenes = @guidebook.senes
  end

  def show; end

  def new
    @scene = Scene.new(guidebook_id: @guidebook.id)
  end

  def create
    @scene = Scene.create(scene_params)
  end

  def edit; end

  def update
    if @scene.update(scene_params)
      flash[:success] = 'Your scene was updated!'
      redirect_to user_guidebook_scene_path(@user, @guidebook, @scene)
    else
      flash[:error] = @scene.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    @scene.destroy
  end

  def guidebook_scenes
    @scenes = @guidebook.senes
  end

  def select_scene_photo
    @photo = Photo.find_by(id: params[:photo_id])
    respond_to do |format|
      format.js
    end
  end

  private

  def set_user_and_guidebook
    @user = User.friendly.find(params[:user_id])
    @guidebook = Guidebook.find_by_id(params[:guidebook_id])
  end

  def set_scene
    @scene = Scene.find_by_id(params[:id])
  end

  def scene_params
    params.require(:scene).permit(*permitted_params)
  end

  def permitted_params
    %i[guidebook_id photo_id position description]
  end
end
