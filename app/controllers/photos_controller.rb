# frozen_string_literal: true
class PhotosController < ApplicationController

  before_action :set_photo, only: %i[show]

  def index
    find_photos
    @photos = @photos.page(params[:page])
  end

  def find_photos
    set_sort_params

    @photos = Photo.all

    if @sort.present?
      @photos = @photos.order(taken_at: :desc) if @sort[:photos] == 'taken_at'
    end

    @photos = @photos.order('favoritable_total::integer DESC')
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
