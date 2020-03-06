# frozen_string_literal: true
class GuidebookSerializer < ActiveModel::Serializer
  attributes %i[
                id
                name
                description
                category_id
                created_at
                updated_at
                user_id
                scenes
              ]

  def scenes
    # New format with array
    scenes = ActiveModelSerializers::SerializableResource.new(
      object.scenes.order(:position)
    ).as_json[:scenes]
    # Old format with json
    # scenes = {}
    # if object.scenes.reload.any? 
    #   object.scenes.map{|scene| 
    #     gb_p_json = ActiveModelSerializers::SerializableResource.new(scene).as_json
    #     scenes[scene.id.to_s] = gb_p_json[:scene]
    #   }
    # end
    # scenes
  end
end
