class Scene < ApplicationRecord
  belongs_to :photo
  belongs_to :guidebook

  def scenes_ids
    guidebook.scenes.ids
  end

  def index
    scenes_ids.index(id)
  end

  def prev_scene_id
    current_index = index
    return scenes_ids[current_index - 1] if current_index >= 1

    scenes_ids.first
  end

  def prev_scene
    guidebook.scenes.find(prev_scene_id)
  end

  def next_scene_id
    current_index = index
    return scenes_ids[current_index + 1] if current_index < (scenes_ids.size - 1)

    scenes_ids.last
  end

  def next_scene
    guidebook.scenes.find(next_scene_id)
  end
end
