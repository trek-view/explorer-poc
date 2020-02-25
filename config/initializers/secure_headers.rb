SecureHeaders::Configuration.default do |config|
  config.hsts = "max-age=#{1.week.to_i}"
  config.x_frame_options = "DENY"
  config.x_xss_protection = "1; mode=block"
  config.csp = {
    default_src: %w('self' https:),
    font_src:  %w('self' https: data:),
    img_src:  %w('self' https: data: blob:),
    object_src: %w('none'),
    # script_src:  %w('self' https: 'unsafe-inline' https://maps.googleapis.com https://www.google-analytics.com https://www.googletagmanager.com),
    style_src:  %w('self' https: 'unsafe-inline'),
    connect_src: %w('self' https://s3.eu-west-2.amazonaws.com https://backpack.staging.explorer.trekview.org https://backpack.explorer.trekview.org https://a.tiles.mapbox.com),
    # script_src:  %w('self'),
    script_src:  %w('self' https: 'unsafe-inline' https://maps.googleapis.com),
    worker_src: %w(blob:),
    report_uri: %w(https://report-uri.io/example-csp),
    preserve_schemes: true,
  }
end
