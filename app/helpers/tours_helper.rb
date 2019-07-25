# frozen_string_literal: true
module ToursHelper

  def countries_for_select
    Country.all.map {|country| [country.name, country.id]}
  end

  def tour_types_for_select
    Tour.tour_types.map {|k , v| [k, v] }
  end

end