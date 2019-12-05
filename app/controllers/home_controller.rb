class HomeController < ApplicationController
  include MetaTagsHelper
  def index
    result = ToursFinder.new(params).search

    @tours = result[:tours]
    @tourbooks = result[:tourbooks]
    @sort = result[:sort]
    @query = result[:query]
    @search_text = result[:search_text]

    tour_og_meta_tag(@tours.first) unless @tours.empty?
  end
end
