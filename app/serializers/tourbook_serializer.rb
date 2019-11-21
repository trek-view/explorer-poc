# frozen_string_literal: true
class TourbookSerializer < ActiveModel::Serializer
  attributes %i[
                id
                name
                description
                created_at
                updated_at
              ]

  # has_many :tours
end
