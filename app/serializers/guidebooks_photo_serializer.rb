# frozen_string_literal: true
class SceneSerializer < ActiveModel::Serializer
  attributes %i[id photo_id description position]
end
