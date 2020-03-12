# frozen_string_literal: true
class PhotosController < ApplicationController
  include MetaTagsHelper

  before_action :authenticate_user!, only: %i[set_photo_view_point]
  before_action :set_viewpoints_search_params, only: [:viewpoints]
  before_action :set_guidebook_scene_photo_params, only: %i[guidebook_scene_photo]

  before_action :set_viewpoint_photo, only: %i[show]
  before_action :set_photo, only: %i[guidebook_scene_photo]
  before_action :set_user, only: %i[viewpoints guidebook_scene_photo]
  before_action :set_tour, only: %i[show guidebook_scene_photo]
  before_action :set_guidebook, only: %i[guidebook_scene_photo]
  before_action :set_scene, only: %i[guidebook_scene_photo]

  before_action :set_guidebooks, only: %i[show guidebook_scene_photo]
  before_action :set_connected_photos, only: %i[show guidebook_scene_photo]

  def index
    find_photos
    @photos = @photos.page(params[:page]).per(Constants::WEB_ITEMS_PER_PAGE[:photos])
    photo_og_meta_tag(@photos.first) unless @photos.empty?
  end

  def viewpoints
    find_viewpoints
    @photos = @photos.page(params[:page]).per(Constants::WEB_ITEMS_PER_PAGE[:photos])
    photo_og_meta_tag(@photos.first) unless @photos.empty?
  end

  def show
    photo_og_meta_tag(@photo)

    gon.pannellum_config = pannellum_config
    gon.photos = @tour.photos
    gon.tour_name = @tour.name
    gon.author_name = @tour.user.name
    gon.root_url = root_url
  end

  def find_photos
    set_sort_params

    @photos = Photo.all

    if @sort.present?
      @photos = @photos.order(taken_at: :desc) if @sort[:photos] == 'taken_at'
      @photos = @photos.order(filename: :asc) if @sort[:photos] == 'filename'
    end

    @photos = @photos.order("cast(substring(favoritable_score from 15) as int) DESC")
  end

  def find_viewpoints
    set_sort_params
    if @user.present?
      @photos = @user.photos
    else
      @photos = Photo.where("cast(substring(favoritable_score from 15) as int) > 0")
    end

    search_viewpoints

    if @sort.present?
      @photos = @photos.order(taken_at: :desc) if @sort[:photos] == 'taken_at'
      @photos = @photos.order(filename: :desc) if @sort[:photos] == 'filename'
    end

    @photos = @photos.order('cast(substring(favoritable_score from 15) as int) DESC')
  end

  def guidebook_scene_photo
    photo_og_meta_tag(@photo)

    gon.pannellum_config = pannellum_config
    gon.photos = @tour.photos
    gon.tour_name = @tour.name
    gon.author_name = @tour.user.name
    gon.root_url = root_url
  end

  private

  def set_photo
    @photo = Photo.find_by(id: params[:id]) if params[:id]
  end

  def set_viewpoint_photo
    @photo = Photo.includes(tour: :user).find(params[:id])
  end

  def set_sort_params
    @sort = sort_params[:sort]
  end

  def sort_params
    params.permit(sort: %i[photos top])
  end

  def set_user
    @user = if params[:user_id]
              User.friendly.find(params[:user_id])
            elsif params[:user]
              User.friendly.find(params[:id])
            end
  end

  def pannellum_config
    # photos = []
    # node_stack = [@photo]

    # max_limit = 10000
    # loop_count = 0

    # loop do
    #   break if loop_count > max_limit
    #   break if node_stack.empty?

    #   curr_node = node_stack.pop
    #   photos << curr_node unless photos.include?(curr_node)

    #   next unless curr_node
    #   next unless curr_node.tourer["connections"].present?

    #   connections = JSON.parse(curr_node.tourer["connections"])

    #   connections&.keys&.each do |key|
    #     photo = @photo.tour.photos.find_by(tourer_photo_id: connections[key]["photo_id"])

    #     if photo && !photos.include?(photo)
    #       node_stack << photo
    #     end
    #   end

    #   loop_count += 1
    # end

    options = {
      "autoLoad": true,
        "default": {
            "firstScene": @photo.tourer_photo_id,
            "title": @tour.name,
            "author": @tour.user.name,
            "authorURL": photo_path(@photo),
            "sceneFadeDuration": 0
        },
        "scenes": {}
    }

    @tour.photos.each do |photo|
      next unless photo.tourer["connections"]
      begin
        connections = JSON.parse(photo.tourer["connections"])
        hot_spots = []
        connections&.keys&.each do |key|
          hot_photo = @tour.photos.select{ |connected_photo| connected_photo.tourer_photo_id == connections[key]["photo_id"] }.first
          if hot_photo
            hot_spots << {
                "type": "scene",
                "pitch": connections[key]["pitch_degrees"].to_f,
                "yaw": connections[key]["adjusted_heading_degrees"].to_f,
                "text": hot_photo.tourer_photo_id,
                "sceneId": hot_photo.tourer_photo_id
            }
          end
        end
      rescue => exception
        puts "=== exception: #{exception.inspect}"
      end

      options[:scenes][photo.tourer["photo_id"]] = {
        "title": @tour.name,
        "author": @tour.user.name,
        "authorURL": photo_path(photo),
        "type": "equirectangular",
        "panorama": photo.image_path,
        "hotSpots": hot_spots
      }
    end

    options
  end

  def set_viewpoints_search_params
    @search_text = viewpoints_search_params[:search_text]
    @query = viewpoints_search_params[:query]
  end

  def viewpoints_search_params
    params.permit(:search_text, query: %i[country_id tour_type transport_type])
  end

  def search_viewpoints
    return unless @query.present?

    @photos = @photos.where(country_id: @query[:country_id]) if @query[:country_id].present?
  end

  def set_guidebook_scene_photo_params
    params.permit(:user_id, :guidebook_id, :scene_id, :id)
  end

  def set_tour
    @tour = @photo.tour
  end

  def set_guidebook
    @guidebook = Guidebook.find_by_id(params[:guidebook_id]) if params[:guidebook_id].present?
  end

  def set_scene
    @scene = Scene.find_by_id(params[:scene_id]) if params[:scene_id].present?
  end

  def set_connected_photos
    @connected_photos = []

    begin
      connections = JSON.parse(@photo.tourer['connections']) if @photo.tourer['connections']
      connections&.keys&.each do |key|
        photo = @tour.photos.find_by(tourer_photo_id: connections[key]["photo_id"])
        if photo
          @connected_photos << photo
        end
      end
    rescue => exception
      puts "=== exception: #{exception.inspect}"
    end
  end

  def set_guidebooks
    @guidebooks = @photo.guidebooks
  end
end
