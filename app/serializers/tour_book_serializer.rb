class TourBookSerializer < ActiveModel::Serializer
  attributes %i[
                id
                reference
                name
                description
              ]
end
