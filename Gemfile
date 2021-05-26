# frozen_string_literal: true

source 'https://rubygems.org'

DECIDIM_VERSION = '0.24.2'

ruby RUBY_VERSION

gem 'execjs', '= 2.7.0'

gem 'decidim', DECIDIM_VERSION
gem 'decidim-proposals', DECIDIM_VERSION
# gem 'decidim-consultations', DECIDIM_VERSION
# gem 'decidim-initiatives', DECIDIM_VERSION
gem 'decidim-decidim_awesome', git: 'https://github.com/Platoniq/decidim-module-decidim_awesome.git', ref: 'custom-fields'
gem 'decidim-navigation_maps', '~> 1.2.0'

gem 'decidim-anonymous_proposals',
    git: 'https://github.com/PopulateTools/decidim-module-anonymous_proposals',
    branch: :main
gem 'decidim-homepage_interactive_map',
    git: 'https://github.com/puzzle/decidim-module-homepage_interactive_map.git',
    tag: DECIDIM_VERSION
gem 'decidim-term_customizer',
    git: 'https://github.com/mainio/decidim-module-term_customizer'
gem 'decidim-url_aliases',
    git: 'https://github.com/OpenSourcePolitics/decidim-urlaliases'

gem 'bootsnap', '~> 1.3'

gem 'dalli'
gem 'delayed_job_active_record'
gem 'faker', '~> 1.9'
gem 'omniauth_openid_connect'
gem 'prometheus_exporter'
gem 'pry-rails'
gem 'puma'
gem 'uglifier', '~> 4.1'

group :development, :test do
  gem 'byebug', '~> 11.0', platform: :mri
  gem 'pry-byebug'

  gem 'decidim-dev', DECIDIM_VERSION
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'letter_opener_web', '~> 1.3'
  gem 'listen', '~> 3.1'
  gem 'spring', '~> 2.0'
  gem 'spring-watcher-listen', '~> 2.0'
  gem 'web-console', '~> 3.5'
end

group :production do
  gem 'bleib'
end
