# frozen_string_literal: true

source 'https://rubygems.org'

DECIDIM_VERSION = '0.26.1'

ruby RUBY_VERSION

gem 'execjs' #, '= 2.7.0'

gem 'decidim', DECIDIM_VERSION
gem 'decidim-proposals', DECIDIM_VERSION
# gem 'decidim-consultations', DECIDIM_VERSION
# gem 'decidim-initiatives', DECIDIM_VERSION
gem 'decidim-antivirus', git: 'https://github.com/puzzle/decidim-module-antivirus'
gem 'decidim-conferences', DECIDIM_VERSION

gem 'decidim-decidim_awesome',
    git: 'https://github.com/Platoniq/decidim-module-decidim_awesome'
gem "decidim-anonymous_proposals",
    git: "https://github.com/puzzle/decidim-module-anonymous_proposals",
    branch: "release/0.26-stable"
gem 'decidim-term_customizer',
    git: 'https://github.com/puzzle/decidim-module-term_customizer',
    branch: "v0.26"

gem 'omniauth-openid-connect', git: 'https://github.com/netsphere-labs/omniauth-openid-connect.git'

gem 'aws-sdk-s3'
gem 'bootsnap'
gem 'dalli'
gem 'delayed_job_active_record'
gem 'faker', '~> 1.9'
gem 'omniauth_openid_connect'
gem 'lograge'
gem 'prometheus_exporter'
gem 'pry-rails'
gem 'puma'
gem 'sentry-raven'
gem 'uglifier'                 #, '~> 4.1'

group :development, :test do
  gem 'byebug', platform: :mri #, '~> 11.0'
  gem 'pry-byebug'

  gem 'decidim-dev', DECIDIM_VERSION
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'letter_opener_web'      #, '~> 1.3'
  gem 'listen'                 #, '~> 3.1'
  gem 'spring'                 #, '~> 2.0'
  gem 'spring-watcher-listen'  #, '~> 2.0'
  gem 'web-console'            #, '~> 3.5'
end

group :production do
  gem 'bleib'
end
