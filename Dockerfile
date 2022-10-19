##################################################################
#                            Build Stage                         #
##################################################################

FROM ruby:2.7 AS build

ARG BUILD_PACKAGES="git libicu-dev libpq-dev"
ARG BUILD_SCRIPT="npm install -g npm && \
    npm install -g yarn && \
    yarn set version 1.22.10"
ARG BUNDLE_WITHOUT="development:metrics:test"
ARG BUNDLER_VERSION="2.3.22"
ARG POST_BUILD_SCRIPT="bundle exec rails assets:precompile"
ARG SKIP_MEMCACHE_CHECK="true"
ARG RAILS_ENV="production"
ARG SECRET_KEY_BASE="thisneedstobeset"

# Set build shell
SHELL ["/bin/bash", "-c"]

# Use root user
USER root

# Install packages needed at buildtime
RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y ${BUILD_PACKAGES}

# Installs nodejs as a dependency
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - \
 && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg -o /root/yarn-pubkey.gpg && apt-key add /root/yarn-pubkey.gpg \
 && echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    nodejs \
 && apt-get clean \
 && rm -rf /var/cache/apt/archives/* \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
 && truncate -s 0 /var/log/*log

RUN [[ ${BUILD_SCRIPT} ]] && bash -c "${BUILD_SCRIPT}"

# Install specific versions of dependencies
RUN gem install bundler:${BUNDLER_VERSION} --no-document

# TODO: Load artifacts

COPY ./Gemfile ./Gemfile.lock /app-src/
WORKDIR /app-src

# Run deployment
RUN bundle config set --local deployment 'true' \
 && bundle config set --local without ${BUNDLE_WITHOUT} \
 && bundle package \
 && bundle install \
 && bundle clean

COPY ./package.json ./yarn.lock /app-src/
RUN yarn

# set up app-src directory
COPY . /app-src

RUN [[ ${POST_BUILD_SCRIPT} ]] && bash -c "${POST_BUILD_SCRIPT}"

# TODO: Save artifacts

RUN rm -rf vendor/cache/ .git

##################################################################
#                            Run Stage                           #
##################################################################

# This image will be replaced by Openshift
FROM ruby:2.7-slim AS app

# Set runtime shell
SHELL ["/bin/bash", "-c"]

# Add user
RUN adduser --disabled-password --uid 1001 --gid 0 --gecos "" --shell /bin/bash app
# RUN adduser --disabled-password --uid 1002 --gid 0 --gecos "" clamav

ARG BUNDLE_WITHOUT='development:metrics:test'
ARG BUNDLER_VERSION="2.3.22"
ARG RUN_PACKAGES="clamav clamav-daemon git graphicsmagick libicu-dev libpq5 nodejs poppler-utils"
ARG PS1='$SENTRY_CURRENT_ENV:$PWD$ '
ENV PS1=$PS1
ARG TZ="Europe/Zurich"
ENV TZ=$TZ
ENV PATH=/app-src/bin:$PATH


# Prepare apt-get
RUN export DEBIAN_FRONTEND=noninteractive \
 && apt-get update \
 && apt-get upgrade -y \
    # Install libpaper1 seperately, because statx is broken on APPUiO build
 && apt-get install -y ucf \
 && apt-get download libpaper1 \
 && dpkg --unpack libpaper1*.deb \
 && rm /var/lib/dpkg/info/libpaper1\:amd64.postinst \
 && dpkg --configure libpaper1 \
 && apt-get install -yf \
 && rm libpaper1*.deb \
    # Install the Packages we need at runtime
 && apt-get -y install ${RUN_PACKAGES} \
    vim curl \
    # HACK: Maybe move to different image... gives clamav the right to execute
 && usermod -a -G 0 clamav \
    # Clean up after ourselves
 && unset DEBIAN_FRONTEND \
    # Install specific versions of dependencies
 && gem install bundler:${BUNDLER_VERSION} --no-document

# Copy deployment ready source code from build
COPY --from=build /app-src /app-src
COPY docker/ /
WORKDIR /app-src

RUN chgrp -R 0 /app-src \
 && chmod -R u+w,g=u /app-src
# HACK: Maybe move to different image... Set group permissions to app folder and help clamav to start
RUN    mkdir /var/run/clamav \
 && chown clamav /run/clamav \
 && sed -i 's/^chown/# chown/' /etc/init.d/clamav-daemon \
 && chgrp -R 0 \
    /app-src \
    /var/log/clamav \
    /var/lib/clamav \
    /var/run/clamav \
    /run/clamav \
 && chmod -R u+w,g=u \
    /app-src \
    /var/log/clamav \
    /var/lib/clamav \
    /var/run/clamav \
    /run/clamav \
 && freshclam


ENV HOME=/app-src

USER 1000

# Use cached gems
RUN bundle config set --local deployment 'true' \
 && bundle config set --local without ${BUNDLE_WITHOUT} \
 && bundle

CMD ["bundle", "exec", "puma", "-t", "8"]
