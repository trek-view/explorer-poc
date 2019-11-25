# frozen_string_literal: true
class PhotosController < ApplicationController

  def index
    @photos = Photo.order('created_at DESC')
  end

end
