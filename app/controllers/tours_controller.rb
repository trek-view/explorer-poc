# frozen_string_literal: true
class ToursController < ApplicationController

  before_action :set_tour, only: %i[show]

  def index
    @tours = Tour.all.page(params[:page])
  end

  def show; end

  private

    def set_tour
      @tour = Tour.friendly.find(params[:id])
    end

end