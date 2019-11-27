# frozen_string_literal: true
class PhotosController < ApplicationController

  before_action :set_photo, only: %i[show]

  def index
    @photos = Photo.order('favoritable_total::integer DESC').page(params[:page])
  end

  def show

  end

  private

  def set_photo
    @photo = Photo.includes(tour: :user).find(params[:id])
  end

end
