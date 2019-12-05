# frozen_string_literal: true
class PhotosController < ApplicationController
  include MetaTagsHelper

  before_action :authenticate_user!, only: %i[set_photo_view_point]
  before_action :set_photo, only: %i[show
                                      set_photo_view_point]

  def index
    find_photos
    @photos = @photos.page(params[:page])   
    photo_og_meta_tag(@photos.first) unless @photos.empty?
  end

  def show
    photo_og_meta_tag(@photo)
  end

  def find_photos
    set_sort_params

    @photos = Photo.all

    if @sort.present?
      @photos = @photos.order(taken_at: :desc) if @sort[:photos] == 'taken_at'
    end

    @photos = @photos.order('substring(favoritable_score from 15)::integer ASC')
  end

  private

  def set_photo
    @photo = Photo.includes(tour: :user).find(params[:id])
  end

  def set_sort_params
    @sort = sort_params[:sort]
  end

  def sort_params
    params.permit(sort: [:photos])
  end
end
