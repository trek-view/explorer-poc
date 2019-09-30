# frozen_string_literal: true
class PhotosController < ApplicationController

  def index
    @photos = Photo.joins(:view_points)
                    .select('photos.*, count(view_points.id) as count_view_points')
                    .group('photos.id')
                    .order('count_view_points DESC')
  end

end
