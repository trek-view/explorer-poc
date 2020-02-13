class HomeController < ApplicationController
  include MetaTagsHelper
  def index
    @home_cards = HomeCard.all.order(:priority)
  end

  def about
    render 'about/index'
  end
  
end
