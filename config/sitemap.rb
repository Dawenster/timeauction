# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = ENV["AWS_BUCKET"] == "timeauction-hk" ? "https://www.timeauction.hk" : "https://www.timeauction.org"

SitemapGenerator::Sitemap.create do
  Auction.find_each do |auction|
    add auction_path(auction), :lastmod => auction.updated_at
  end

  User.find_each do |user|
    add user_path(user), :lastmod => user.updated_at
  end

  Organization.find_each do |organization|
    add organization_path(organization), :lastmod => organization.updated_at
  end

  add "/testimonials"
  add "/media"
  add "/faq"
  add "/opportunities"
  add "/email-alerts"
  add "/contact"
  add "/terms-and-conditions"
  add "/privacy-and-security"

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
end
