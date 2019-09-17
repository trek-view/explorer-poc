# frozen_string_literal: true
module ApplicationHelper

  def current_class?(test_path)
    request.path == test_path ? 'active' : ''
  end

  def app_description
    "Application to see tour's descriptions and photos posted by other users"
  end

  def app_image
    image_url('google-street-view-tours.jpg')
  end

  def app_url
    root_url
  end

  def set_user
    @user = if params[:user_id]
              User.friendly.find(params[:user_id])
            elsif params[:user]
              User.friendly.find(params[:id])
            else
              current_user
            end
  end

  def form_errors_for(object=nil)
    render('shared/form_errors', object: object) unless object.blank?
  end

end
