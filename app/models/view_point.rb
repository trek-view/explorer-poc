# frozen_string_literal: true
class ViewPoint < ApplicationRecord

  belongs_to :user
  belongs_to :photo, counter_cache: :view_points_count

  validates_uniqueness_of :photo_id, scope: :user_id, message: 'has already been marked.'

end
