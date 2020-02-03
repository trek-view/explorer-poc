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
      object.guidebooks_photos.order('position ASC')
    ).as_json[:guidebooks_photos]
    # Old format with json
    # scenes = {}
    # if object.guidebooks_photos.reload.any? 
    #   object.guidebooks_photos.map{ |guidebooks_photo| 
    #     puts "===== gb_p: #{guidebooks_photo.inspect}"
    #     gb_p_json = ActiveModelSerializers::SerializableResource.new(guidebooks_photo).as_json
    #     puts "===== json: #{gb_p_json.inspect}"
    #     puts "===== guidebooks_photo: #{gb_p_json[:guidebooks_photo]}"
    #     scenes[guidebooks_photo.id.to_s] = gb_p_json[:guidebooks_photo]
    #   }
    # end
    # scenes
  end

end
