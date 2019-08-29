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
            script_src:  %w('self' https: 'unsafe-inline' https://maps.googleapis.com https://www.google-analytics.com https://www.googletagmanager.com),
            style_src:  %w('self' https: 'unsafe-inline'),
            connect_src: %w('self'),
            report_uri: %w(https://report-uri.io/example-csp)}
  )

  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from Pundit::NotAuthorizedError do |exception|
    respond_to do |format|
      format.json { head :unauthorized, content_type: 'text/html' }
      format.html { user_not_authorized }
      format.js   { head :unauthorized, content_type: 'text/html' }
    end
  end

  def sitemap
    aws_s3_url = "http://s3.#{ENV['FOG_REGION']}.amazonaws.com/#{ENV['FOG_DIRECTORY']}/sitemaps/sitemap.xml.gz"
    redirect_to(aws_s3_url, status: 301)
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
