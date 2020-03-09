class SceneSerializer < ActiveModel::Serializer
  attributes %i[
    id
    position
    photo_id
    title
    description
    tags
  ]

  def tags
    object.tags.map(&:name)
  end
end