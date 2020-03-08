class Scene < ApplicationRecord
  belongs_to :photo
  belongs_to :guidebook
  # has_many :scenes_tags
  has_and_belongs_to_many :tags

  def guidebook_scenes_ids
    guidebook.scenes.ids
  end

  def index
    guidebook_scenes_ids.index(id)
  end

  def prev_scene_id
    current_index = index
    return guidebook_scenes_ids[current_index - 1] if current_index >= 1

    guidebook_scenes_ids.first
  end

  def prev_scene
    guidebook.scenes.find(prev_scene_id)
  end

  def next_scene_id
    current_index = index
    return guidebook_scenes_ids[current_index + 1] if current_index < (guidebook_scenes_ids.size - 1)

    guidebook_scenes_ids.last
  end

  def next_scene
    guidebook.scenes.find(next_scene_id)
  end

  def self.tagged_with(name)
    Tag.find_by!(name: name).posts
  end

  def self.tag_counts
    Tag.select('tags.*, count(taggings.tag_id) as count').joins(:taggings).group('taggings.tag_id')
  end

  def tag_list
    tags.map(&:name).join(', ')
  end

  def tag_list=(names)
    self.tags = names.split(',').map do |n|
      Tag.where(name: n.strip).first_or_create!
    end
  end
end
