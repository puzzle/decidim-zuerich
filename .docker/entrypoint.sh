#!/bin/bash

set -e

bin/rails db:migrate RAILS_ENV=development

echo "Decidim::System::Admin.where(email: 'decidim_zuerich@puzzle.ch').first_or_initialize.update!(password: 'decidim', password_confirmation: 'decidim')" | bundle exec rails console

if [ ! -f "/db-init/done" ]; then
  echo 'ActiveRecord::Base.connection.execute(IO.read(".docker/database-init.sql"))' | bundle exec rails console
  echo 'user = Decidim::User.where(email: "decidim_zuerich@puzzle.ch").first; user.invite!; "*************************************************** ACTIVATE YOUR ACCOUNT **************************************************** decidim_zuerich@puzzle.ch / decidim on http://localhost:3000/users/invitation/accept?invitation_token=#{user.raw_invitation_token}"' | bundle exec rails console
  date > /db-init/done
else
  echo "Skipping database initialization because already done on $(cat /db-init/done)"
fi

# Fix bundler / rubygems / rails bug that causes puma to fail
# https://github.com/rubygems/rubygems/issues/3279
bundle binstubs bundler --force

exec "$@"
