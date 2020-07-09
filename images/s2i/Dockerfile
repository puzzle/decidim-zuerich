FROM centos/ruby-25-centos7

USER root

ADD ./root /

RUN bash -c "gem install bundler -v \"$(grep -A 1 'BUNDLED WITH' /opt/app-root/src/Gemfile.lock | tail -n 1)\""

RUN \
  set -x && \
  ## FIXME: why does ruby-25 need to be disabled for the build to work
  curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo && \
  curl --silent --location https://rpm.nodesource.com/setup_12.x | sudo bash - && \
  yum-config-manager --disable cbs.centos.org_repos_sclo7-rh-ruby25-rh-candidate_x86_64_os_ && \
  yum  install -y \
  # for active storage gem
  ImageMagick poppler libpoppler libicu-devel yarn && \
  # Call restore-artifacts script when assembling
  sed '/Installing application source/i $STI_SCRIPTS_PATH/restore-artifacts' \
    -i $STI_SCRIPTS_PATH/assemble && \
  # Call post-assemble script when assembling
  echo -e "\n\$STI_SCRIPTS_PATH/post-assemble" >> $STI_SCRIPTS_PATH/assemble

USER 1001

ENV RAILS_ENV=production
