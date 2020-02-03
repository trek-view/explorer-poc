# frozen_string_literal: true
class GuidebooksPhotoSerializer < ActiveModel::Serializer
  attributes %i[
                id
                photo_id
                description
                position
              ]
end
