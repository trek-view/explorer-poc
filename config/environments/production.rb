Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Ensures that a master key has been made available in either ENV["RAILS_MASTER_KEY"]
  # or in config/master.key. This key is used to decrypt credentials (and other encrypted files).
  # config.require_master_key = true

  # Disable serving static files from the `/public` folder by default since
  # Apache or NGINX already handles this.
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  # Compress JavaScripts and CSS.
  config.assets.js_compressor = :uglifier
  # config.assets.css_compressor = :sass

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false

  # `config.assets.precompile` and `config.assets.version` have moved to config/initializers/assets.rb

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.action_controller.asset_host = 'http://assets.example.com'

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = 'X-Sendfile' # for Apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for NGINX

  # Store uploaded files on the local file system (see config/storage.yml for options)
  # config.active_storage.service = :local

  # Mount Action Cable outside main process or domain
  # config.action_cable.mount_path = nil
  # config.action_cable.url = 'wss://example.com/cable'
  # config.action_cable.allowed_request_origins = [ 'http://example.com', /http:\/\/example.*/ ]

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # Use the lowest log level to ensure availability of diagnostic information
  # when problems arise.
  config.log_level = :debug

  # Prepend all log lines with the following tags.
  config.log_tags = [ :request_id ]

  # Use a different cache store in production.
  # config.cache_store = :mem_cache_store

  # Use a real queuing backend for Active Job (and separate queues per environment)
  # config.active_job.queue_adapter     = :resque
  # config.active_job.queue_name_prefix = "explorer_#{Rails.env}"

  config.action_mailer.perform_caching = false

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  # Use a different logger for distributed setups.
  # require 'syslog/logger'
  # config.logger = ActiveSupport::TaggedLogging.new(Syslog::Logger.new 'app-name')

  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  # config.action_mailer.raise_delivery_errors = false
  # config.action_mailer.default charset: "utf-8"
  # config.action_mailer.asset_host = 'https://dev-explorer.herokuapp.com'
  config.action_mailer.default_url_options = { host: 'dev-explorer.herokuapp.com', protocol: 'https' }

  config.action_mailer.smtp_settings = {
      user_name: Explorer.credentials[:smtp_user_name],
      password:  Explorer.credentials[:smtp_password],
      domain:    Explorer.credentials[:smtp_domain],
      address:   Explorer.credentials[:smtp_address],
      port:      Explorer.credentials[:smtp_port],
      authentication: :plain,
      enable_starttls_auto: true
  }

  config.cookies = {
      secure: true, # mark all cookies as "Secure"
      httponly: true, # mark all cookies as "HttpOnly"
      samesite: {
          lax: true # mark all cookies as SameSite=lax
      }
  }
  # Add "; preload" and submit the site to hstspreload.org for best protection.
  config.secure_headers.hsts = "max-age=#{1.week.to_i}"
  config.secure_headers.x_frame_options = "DENY"
  config.secure_headers.x_content_type_options = "nosniff"
  config.secure_headers.x_xss_protection = "1; mode=block"
  config.secure_headers.x_download_options = "noopen"
  config.secure_headers.x_permitted_cross_domain_policies = "none"
  config.secure_headers.referrer_policy = %w(origin-when-cross-origin strict-origin-when-cross-origin)
  config.secure_headers.csp = {
      # "meta" values. these will shape the header, but the values are not included in the header.
      preserve_schemes: true, # default: false. Schemes are removed from host sources to save bytes and discourage mixed content.

      # directive values: these values will directly translate into source directives
      default_src: %w('none'),
      base_uri: %w('self'),
      block_all_mixed_content: true, # see http://www.w3.org/TR/mixed-content/
      child_src: %w('self'), # if child-src isn't supported, the value for frame-src will be set.
      connect_src: %w(wss:),
      font_src: %w('self' data:),
      form_action: %w('self' github.com),
      frame_ancestors: %w('none'),
      img_src: %w(mycdn.com data:),
      manifest_src: %w('self'),
      media_src: %w(utoob.com),
      object_src: %w('self'),
      sandbox: true, # true and [] will set a maximally restrictive setting
      plugin_types: %w(application/x-shockwave-flash),
      script_src: %w('self'),
      style_src: %w('unsafe-inline'),
      worker_src: %w('self'),
      upgrade_insecure_requests: true, # see https://www.w3.org/TR/upgrade-insecure-requests/
      report_uri: %w(https://report-uri.io/example-csp)
  }
  # This is available only from 3.5.0; use the `report_only: true` setting for 3.4.1 and below.
  config.secure_headers.csp_report_only = config.csp.merge({
                                                img_src: %w(somewhereelse.com),
                                                report_uri: %w(https://report-uri.io/example-csp-report-only)
                                            })
end
