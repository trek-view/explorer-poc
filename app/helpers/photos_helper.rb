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

  def display_vote_column?(ctrl, action)
    ctrl == 'tours' && action == 'show'
  end

  def tour_thumb_url(tour)
    if tour.photos.nil?
      return nil
    end

    photo = tour.photos.find {|photo| photo.image.thumb.url.present?}
    photo_thumb_url(photo)
  end

  def tourbook_thumb_url(tourbook)
    if tourbook.tours.nil?
      return nil
    end

    tourbook.tours.each do |tour|
      thumb_url = tour_thumb_url(tour)
      if thumb_url.present?
        return thumb_url
      end
    end    
  end

  def photo_thumb_url(photo)
    if photo.present?
      photo.image.thumb.url  
    end
  end

end
