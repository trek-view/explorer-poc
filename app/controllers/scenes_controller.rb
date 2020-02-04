class ScenesController < ApplicationController
  before_action :set_user_and_guidebook
  before_action :set_scene, only: %i[show update destroy]

  def index
    @scenes = @guidebook.senes
  end

  def show
    @scene
  end

  def new
    @scene = Scene.new(guidebook_id: @guidebook.id)
  end

  def create
    # @scene = Scene.create(create_params)
  end

  def update
    # @scene.update(update_params)
  end

  def destroy
    @scene..destroy
  end

  def guidebook_scenes
    @scenes = @guidebook.senes
  end

  private

  def set_user_and_guidebook
    @user = User.find(id: params[:user_id])  
    @guidebook = Guidebook.find(id: params[:guidebook_id])
  end

  def set_scene
    @scene = Scene.find(id: params[:id])
  end
end
