# frozen_string_literal: true
module PhotosHelper

  def view_point_class(photo, user)
    photo.check_view_points(user) ? 'fa-heart' : 'fa-heart-o'
  end

  def set_photo_view_point_url(user, tour, photo)
    if photo.check_view_points(user)
      unset_photo_view_point_user_tour_path(user, tour, photo_id: photo.id)
    else
      set_photo_view_point_user_tour_path(user, tour, photo_id: photo.id)
    end
  end

  def set_link_method(photo, user)
    photo.check_view_points(user) ? :delete : :post
  end

end
