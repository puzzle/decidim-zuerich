# frozen_string_literal: true

source 'https://rubygems.org'

DECIDIM_VERSION = '0.29.7'

ruby RUBY_VERSION

# Decidim
gem 'decidim',
    github: 'openpoke/decidim',
    branch: '0.29-backports',
    ref: '9a4d36f316a2509e5d31ae3d20825d7af5a81523'

# Internal Modules
## gem 'decidim-consultations', DECIDIM_VERSION
## gem 'decidim-initiatives', DECIDIM_VERSION
# gem 'decidim-proposals', DECIDIM_VERSION
# gem 'decidim-conferences', DECIDIM_VERSION
# gem 'decidim-templates', DECIDIM_VERSION

gem 'decidim-proposals',
    github: 'openpoke/decidim',
    branch: '0.29-backports',
    ref: '9a4d36f316a2509e5d31ae3d20825d7af5a81523',
    glob: 'decidim-proposals/*.gemspec'

gem 'decidim-conferences',
    github: 'openpoke/decidim',
    branch: '0.29-backports',
    ref: '9a4d36f316a2509e5d31ae3d20825d7af5a81523',
    glob: 'decidim-conferences/*.gemspec'

gem 'decidim-templates',
    github: 'openpoke/decidim',
    branch: '0.29-backports',
    ref: '9a4d36f316a2509e5d31ae3d20825d7af5a81523',
    glob: 'decidim-templates/*.gemspec'

# HACK: Using patched version of deface, to fix decidim-geo JS Errors
gem 'deface',
    github: 'froger/deface',
    branch: 'fix/js-overrides'

# External Modules
gem 'decidim-anonymous_codes',
    github: 'openpoke/decidim-module-anonymous_codes',
    branch: 'main',
    ref: '8323978'
gem 'decidim-anonymous_proposals',
    github: 'openpoke/decidim-module-anonymous_proposals',
    branch: 'main',
    ref: '54aa291'
gem 'decidim-antivirus',
    github: 'puzzle/decidim-module-antivirus',
    branch: 'master',
    ref: 'bc3cb4d'
gem 'decidim-decidim_awesome',
    github: 'decidim-ice/decidim-module-decidim_awesome',
    branch: 'release/0.29-stable',
    ref: '8148f25df903438a712ab24ed589a13a36846de2'
gem 'decidim-decidim_geo',
    git: 'https://git.octree.ch/decidim/decidim-module-geo',
    branch: 'main',
    ref: 'a9ad70e5221bbc5019589e6bd48aa38c2526fdaf'
gem 'decidim-guest_meeting_registration',
    github: 'OpenSourcePolitics/guest-meeting-registration',
    branch: 'bump/module_to_0.29',
    ref: '19e3998'
gem 'decidim-participatory_documents',
    github: 'openpoke/decidim-module-participatory-documents',
    branch: 'main',
    ref: '21501f8'
gem 'decidim-survey_multiple_answers',
    github: 'OpenSourcePolitics/decidim-module-survey_multiple_answers',
    branch: 'bump/0.29',
    ref: '971ad38'

gem 'decidim-term_customizer',
    github: 'OpenSourcePolitics/decidim-module-term_customizer',
    branch: 'master',
    ref: '3da4973'

gem 'activerecord-postgis-adapter'
gem 'aws-eventstream', '= 1.3.0'
gem 'aws-partitions', '= 1.927.0'
gem 'aws-sdk-core', '= 3.195.0'
gem 'aws-sdk-kms', '= 1.80.0'
gem 'aws-sdk-s3', '= 1.149.1'
gem 'aws-sigv4', '= 1.8.0'
gem 'bootsnap'
gem 'byebug', platform: :mri
gem 'dalli'
gem 'delayed_job_active_record'
gem 'execjs'
gem 'faker'
gem 'lograge'
gem 'omniauth-openid-connect', git: 'https://github.com/netsphere-labs/omniauth-openid-connect'
gem 'omniauth_openid_connect'
gem 'prometheus_exporter'
gem 'pry-byebug'
gem 'pry-rails'
gem 'puma'
gem 'sentry-delayed_job'
gem 'sentry-rails'
gem 'sentry-ruby'
gem 'sprockets-rails'
gem 'uglifier'

group :development, :test do
  gem 'decidim-dev', DECIDIM_VERSION
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'dotenv'
  gem 'listen'
  gem 'rubocop'
  gem 'web-console'
end

group :production do
  gem 'bleib'
end

# Needs to be loaded after all other delayed_job gems
gem 'delayed_cron_job'
