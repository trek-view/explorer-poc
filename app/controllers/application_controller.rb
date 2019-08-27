# frozen_string_literal: true
class ApplicationController < ActionController::Base

  include Pundit

  ensure_security_headers(
      hsts: {include_subdomains: true, max_age: 20.years.to_i},
      x_frame_options: 'DENY',
      csp: false
  )

  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from Pundit::NotAuthorizedError do |exception|
    respond_to do |format|
      format.json { head :unauthorized, content_type: 'text/html' }
      format.html { user_not_authorized }
      format.js   { head :unauthorized, content_type: 'text/html' }
    end
  end

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :terms, :global_subscribe, :email, :password, :password_confirmation) }
      devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:name, :global_subscribe, :email, :password, :password_confirmation, :current_password) }
    end

  private

    def user_not_authorized
      render file: 'public/401.html', status: :unauthorized
    end

end
