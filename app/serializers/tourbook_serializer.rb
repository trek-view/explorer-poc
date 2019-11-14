# frozen_string_literal: true
class TourbookSerializer < ActiveModel::Serializer
  attributes %i[
                id
                name
                description
                tours
              ]

  has_many :tours
end
