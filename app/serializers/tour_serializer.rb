class TourSerializer < ActiveModel::Serializer

  attributes %i[
                id
                tourer_tour_id
                name
                description
                countries
                tour_type
                transport_type
                tags
              ]

  def countries
    object.countries.any? ? object.countries.pluck(:name) : []
  end

  def tags
    object.tag_names
  end

  has_many :photos

  has_many :countries

end
