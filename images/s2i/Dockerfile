FROM centos/ruby-25-centos7

USER root

ADD ./root /

RUN \
  set -x && \
  ## FIXME: why does ruby-25 need to be disabled for the build to work
  yum-config-manager --disable cbs.centos.org_repos_sclo7-rh-ruby25-rh-candidate_x86_64_os_ && \
  yum install -y http://opensource.wandisco.com/centos/7/git/x86_64/wandisco-git-release-7-2.noarch.rpm && \
  yum install -y \
  # We need a newer git
  git \
  # for active storage gem
  ImageMagick poppler libpoppler libicu-devel && \
  # Call restore-artifacts sscript when assembling
  sed '/Installing application source/i $STI_SCRIPTS_PATH/restore-artifacts' \
    -i $STI_SCRIPTS_PATH/assemble && \
  # Call post-assemble script when assembling
  echo -e "\n\$STI_SCRIPTS_PATH/post-assemble" >> $STI_SCRIPTS_PATH/assemble

RUN bash -c "gem install bundler:2.2.5 --no-document"

USER 1001

ENV RAILS_ENV=production
