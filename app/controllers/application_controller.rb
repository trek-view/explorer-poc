# frozen_string_literal: true
class ApplicationController < ActionController::Base

  include Pundit

  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from Pundit::NotAuthorizedError do |exception|
    respond_to do |format|
      format.json { head :forbidden, content_type: 'text/html' }
      format.html { user_not_authorized }
      format.js   { head :forbidden, content_type: 'text/html' }
    end
  end

  def default_url_options
    { host: request.host, protocol: 'https' }
  end

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    end

  private

    def user_not_authorized
      render file: 'public/401.html', status: :unauthorized
    end

end
