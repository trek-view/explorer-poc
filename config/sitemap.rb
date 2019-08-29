# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = 'https://explorer.trekview.org'
# pick a place safe to write the files
SitemapGenerator::Sitemap.public_path = 'tmp/'
# store on S3 using Fog (pass in configuration values as shown above if needed)
SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new
# inform the map cross-linking where to find the other maps
SitemapGenerator::Sitemap.sitemaps_host = "http://s3.#{ENV['FOG_REGION']}.amazonaws.com/#{ENV['FOG_DIRECTORY']}"
# pick a namespace within your bucket to organize your maps
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'

SitemapGenerator::Sitemap.create do
  add root_path, changefreq: 'daily'

  add tours_path, changefreq: 'weekly'

  Tour.includes(:user).find_each do |tour|
    add user_tour_path(tour.user, tour), changefreq: 'weekly', lastmod: tour.updated_at
  end

end
