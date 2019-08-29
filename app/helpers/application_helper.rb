# frozen_string_literal: true
module ApplicationHelper

  def current_class?(test_path)
    request.path == test_path ? 'active' : ''
  end

  def app_description
    "Application to see tour's descriptions and photos posted by other users"
  end

  def app_image
    image_url('apple-touch-icon-180x180.png')
  end

  def app_url
    root_url
  end

end
