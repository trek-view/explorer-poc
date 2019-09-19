class TourBookSerializer < ActiveModel::Serializer
  attributes %i[
                id
                name
                description
                tours
              ]

  has_many :tours
end
