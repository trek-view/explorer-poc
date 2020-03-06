# frozen_string_literal: true
module PhotosHelper
  def view_point_class(photo, user)
    photo.favorited_by?(user) ? 'fa-heart' : 'fa-heart-o'
  end

  def set_photo_view_point_url(user, tour, photo)
    if photo.favorited_by?(user)
      unset_photo_view_point_user_tour_path(user, tour, photo_id: photo.id)
    else
      set_photo_view_point_user_tour_path(user, tour, photo_id: photo.id)
    end
  end

  def set_link_method(photo, user)
    photo.favorited_by?(user) ? :delete : :post
  end

  def display_vote_column?(ctrl, action)
    ctrl == 'tours' && action == 'show'
  end

  def tour_thumb_url(tour)
    return nil if tour.photos.nil?

    photo = tour.photos.find { |p| p.image.thumb.url.present? }
    photo_thumb_url(photo)
  end

  def tourbook_thumb_url(tourbook)
    return nil if tourbook.tours.nil?

    tourbook.tours.each do |tour|
      thumb_url = tour_thumb_url(tour)
      return thumb_url if thumb_url.present?
    end
  end

  def scene_thumb_url(scene)
    return nil if scene.photo.nil?

    # photo = position.photos.find { |p| p.image.thumb.url.present? }
    photo_thumb_url(scene.photo)
  end

  def guidebook_thumb_url(guidebook)
    return nil if guidebook.scenes.nil?

    guidebook.scenes.each do |scene|
      thumb_url = scene_thumb_url(scene)
      return thumb_url if thumb_url.present?
    end
  end

  def photo_thumb_url(photo)
    # photo.image.thumb.url if photo.present?
    photo.image_thumb_path if photo.present?
  end

  def photo_image_url(photo)
    photo.image_path if photo.present?
  end

  def full_address(address)
    buffer = "".dup
    buffer << "#{address['cafe']} #{address['road']} #{address['state']}"
    buffer << ", #{address['county']}" if address['county'].present?
    buffer << ", #{address['region']}" if address['region'].present?
    buffer << ", #{address['suburb']}" if address['suburb'].present?
    buffer << ", #{address['country']}" if address['country'].present?
    buffer << ", #{address['postcode']}" if address['postcode'].present?
    buffer.sub! '  ,', ''
    buffer
  end

  def aws_s3_bucket_name
    ENV['AWS_S3_BUCKET']
  end

  def mapbox_token
    ENV['MAPBOX_TOKEN']
  end

  def pannellum_iframe(photo)
    '<iframe width="600" height="400" allowfullscreen style="border-style:none;" src="' +
    'https://' + aws_s3_bucket_name() + '/static/pannellum/pannellum.htm' +
    '#panorama=' +
    photo.image_path +
    '&amp;title=' + URI.encode(photo.tour.name) +
    '&amp;author=' + URI.encode(photo.tour.user.name) +
    '&amp;autoLoad=true"></iframe><p><a href="' +
    URI.encode(photo_url(photo)) +
    '" target="_blank">View on Trek View Explorer</a></p>'
  end

  def guidebook_pannellum_iframe(scene)
    photo = scene.photo
    '<iframe width="600" height="400" allowfullscreen style="border-style:none;" src="' +
    'https://' + aws_s3_bucket_name + '/static/pannellum/pannellum.htm' +
    '#panorama=' +
    photo.image_path +
    '&amp;title=' + URI.encode(scene.title || '') +
    '&amp;author=' + URI.encode(scene.guidebook.user.name) +
    '&amp;autoLoad=true"></iframe><p><a href="' +
    URI.encode(photo_url(photo)) +
    '" target="_blank">View on Trek View Explorer</a></p>'
  end
end
