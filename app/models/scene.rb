class Scene < ApplicationRecord
  belongs_to :photo
  belongs_to :guidebook

  def prev_scene_id
    scenes_ids = guidebook.scenes.ids
    current_index = scenes_ids.index(id)

    return scenes_ids[current_index - 1] if current_index >= 1

    scenes_ids.first
  end

  def prev_scene
    guidebook.scenes.find(prev_scene_id)
  end

  def next_scene_id
    scenes_ids = guidebook.scenes.ids
    current_index = scenes_ids.index(id)

    return scenes_ids[current_index + 1] if current_index < (scenes_ids.size - 1)

    scenes_ids.last
  end

  def next_scene
    guidebook.scenes.find(next_scene_id)
  end
end
