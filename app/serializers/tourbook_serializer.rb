# frozen_string_literal: true
class TourbookSerializer < ActiveModel::Serializer
  attributes %i[
                id
                name
                description
                created_at
                user_id
                tour_ids
              ]

  def tour_ids
    object.tours.any? ? object.tours.map(&:id) : []
  end

  # has_many :tours
end
