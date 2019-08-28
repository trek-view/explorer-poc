# frozen_string_literal: true
class ApplicationController < ActionController::Base

  include Pundit

  ensure_security_headers(
      hsts: {include_subdomains: true,
             max_age: 1.week.to_i},
      x_frame_options: 'DENY',
      csp: {default_src: %w('self' https:),
            font_src:  %w('self' https: data:),
            img_src:  %w('self' https: data:),
            object_src: %w('none'),
            script_src:  %w('self' https: 'unsafe-inline' https://maps.googleapis.com https://www.google-analytics.com),
            style_src:  %w('self' https: 'unsafe-inline'),
            connect_src: %w('self'),
            report_uri: %w(https://report-uri.io/example-csp)}
  )

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :check_env

  def check_env
     hash = {
        user_name: ENV['smtp_user_name'],
        password:  ENV['smtp_password'],
        domain:    ENV['smtp_domain'],
        address:   ENV['smtp_address'],
        port:      ENV['smtp_port']
      }
      p hash
  end

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
