# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = 'https://explorer.trekview.org'
SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new(fog_provider: ENV['AWS_FOG_PROVIDER'],
                                                                    aws_access_key_id: ENV['AWS_ACCESS_KEY'],
                                                                    aws_secret_access_key: ENV['AWS_SECRET_KEY'],
                                                                    fog_directory: ENV['AWS_BUCKET_NAME'],
                                                                    fog_region: ENV['AWS_FOG_REGION'])

SitemapGenerator::Sitemap.public_path = 'tmp/'
SitemapGenerator::Sitemap.sitemaps_host = "https://#{ENV['AWS_BUCKET_NAME']}.s3.amazonaws.com/"
SitemapGenerator::Sitemap.sitemaps_path = '/'
SitemapGenerator::Sitemap.ping_search_engines('https://explorer.trekview.org/sitemap')

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end

  add root_path, changefreq: 'daily'

  add tours_path, changefreq: 'weekly'

  Tour.find_each do |tour|
    add user_tour_path(tour.user, tour), changefreq: 'weekly', lastmod: tour.updated_at
  end

end
