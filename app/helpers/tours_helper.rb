module ToursHelper

  def countries_for_select
    Country.all.map {|country| [country.name.capitalize, country.id]}
  end

  def tour_types_for_select
    Tour.tour_types.map {|k , v| [k.capitalize, v] }
  end

end