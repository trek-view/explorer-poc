class HomeController < ApplicationController
  def index
    result = ToursFinder.new(params).search

    @tours = result[:tours]
    @tourbooks = result[:tourbooks]
    @sort = result[:sort]
    @query = result[:query]
    @search_text = result[:search_text]

    set_photo_meta_tags
  end

  private

  def set_photo_meta_tags
    if Rails.env.production?
      tour = @tours.first
      if tour.present? && tour.photos.present?
        photo = tour.photos.first
        set_meta_tags og: {image_src: photo.image.url }
      end
    end
  end
end
