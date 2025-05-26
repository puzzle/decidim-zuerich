# frozen_string_literal: true

source 'https://rubygems.org'

DECIDIM_VERSION = '0.29.3'

ruby RUBY_VERSION

gem 'execjs' # , '= 2.7.0'

gem 'decidim', DECIDIM_VERSION
gem 'decidim-proposals', DECIDIM_VERSION
# gem 'decidim-consultations', DECIDIM_VERSION
# gem 'decidim-initiatives', DECIDIM_VERSION
gem 'decidim-conferences', DECIDIM_VERSION
gem 'decidim-templates', DECIDIM_VERSION

#gem 'decidim-anonymous_codes', github: 'openpoke/decidim-module-anonymous_codes' # deactivated because no compatible version for decidim 0.28 exists
gem 'decidim-anonymous_proposals', github: 'PopulateTools/decidim-module-anonymous_proposals', tag: 'v0.28.0'
gem 'decidim-antivirus', github: 'puzzle/decidim-module-antivirus', branch: 'master'
gem 'decidim-cleaner', github: 'puzzle/decidim-module-cleaner', branch: 'release/0.27-stable'
gem 'decidim-decidim_awesome', github: 'decidim-ice/decidim-module-decidim_awesome', branch: 'main'
#gem 'decidim-decidim_geo', git: 'https://git.octree.ch/decidim/decidim-module-geo.git' # deactivated because no compatible version for decidim 0.28 exists
gem 'decidim-participatory_documents', github: 'openpoke/decidim-module-participatory-documents', branch: 'upgrade-0.29'
#gem 'decidim-question_captcha', github: 'OpenSourcePolitics/decidim-module-question_captcha', branch: 'release/0.27-stable' # deactivated because no compatible version for decidim 0.28 exists
#gem 'decidim-survey_multiple_answers', '~> 0.26.2' # deactivated because no compatible version for decidim 0.28 exists

#gem 'decidim-guest_meeting_registration', github: 'alecslupu-pfa/guest-meeting-registration', branch: 'release/0.27-stable' # deactivated because no compatible version for decidim 0.28 exists

# Had to be set to 0.27-stable because the master reference doesn't exist anymore and the main branch now requires ruby =< 3.1
gem 'decidim-term_customizer', github: 'OpenSourcePolitics/decidim-module-term_customizer', branch: 'master'

gem 'omniauth-openid-connect', git: 'https://github.com/netsphere-labs/omniauth-openid-connect.git'

gem 'activerecord-postgis-adapter'
gem 'acts_as_textcaptcha' # , '~> 4.5.1'
gem 'aws-sdk-s3'
gem 'bootsnap'
gem 'byebug', platform: :mri # , '~> 11.0'
gem 'dalli'
gem 'delayed_job_active_record'
gem 'faker'                    # , '~> 1.9'
gem 'lograge'
gem 'omniauth_openid_connect'
gem 'prometheus_exporter'
gem 'pry-byebug'
gem 'pry-rails'
gem 'puma'
gem 'sentry-raven'
gem 'uglifier'                 # , '~> 4.1'

group :development, :test do
  gem 'decidim-dev', DECIDIM_VERSION
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'listen'                 # , '~> 3.1'
  gem 'rubocop'
  gem 'web-console'            # , '~> 3.5'
end

group :production do
  gem 'bleib'
end

gem 'rectify', '~> 0.13.0'

# Needs to be loaded after all other delayed_job gems
gem 'delayed_cron_job'
