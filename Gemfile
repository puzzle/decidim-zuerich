# frozen_string_literal: true

source 'https://rubygems.org'

DECIDIM_VERSION = '~> 0.23'

ruby RUBY_VERSION

gem 'decidim', DECIDIM_VERSION
gem 'decidim-proposals', DECIDIM_VERSION
# gem 'decidim-consultations', DECIDIM_VERSION
# gem 'decidim-initiatives', DECIDIM_VERSION
gem 'decidim-decidim_awesome', '~> 0.6.6'
gem 'decidim-navigation_maps', '~> 1.1.1'
gem 'decidim-term_customizer', '~> 0.23.0'

gem 'bootsnap', '~> 1.3'

gem 'dalli'
gem 'delayed_job_active_record'
gem 'faker', '~> 1.9'
gem 'prometheus_exporter'
gem 'pry-rails'
gem 'puma', '~> 4.3'
gem 'uglifier', '~> 4.1'

group :development, :test do
  gem 'byebug', '~> 11.0', platform: :mri
  gem 'pry-byebug'

  gem 'decidim-dev', DECIDIM_VERSION
end

group :development do
  gem 'letter_opener_web', '~> 1.3'
  gem 'listen', '~> 3.1'
  gem 'spring', '~> 2.0'
  gem 'spring-watcher-listen', '~> 2.0'
  gem 'web-console', '~> 3.5'
end

group :production do
  gem 'bleib'
end
