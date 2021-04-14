# FIRST STAGE
ARG RUBY_VERSION
FROM docker-hub.iss-reshetnev.ru/registry/languages/ruby:${RUBY_VERSION}-slim-buster-gembuilder AS build

ARG BUNDLER_VERSION
ARG RAILS_ROOT
ARG RAILS_ENV

ENV TZ=Asia/Krasnoyarsk
ENV RAILS_ENV ${RAILS_ENV}
ENV NODE_ENV ${RAILS_ENV}
ENV DEBIAN_FRONTEND noninteractive

# Install bundler
RUN gem install bundler:${BUNDLER_VERSION}
RUN echo 'gem: --no-rdoc --no-ri' > ~/.gemrc

# Create app folder
RUN mkdir -p ${RAILS_ROOT}
WORKDIR ${RAILS_ROOT}

# Install gems
COPY Gemfile* ./
RUN bundle install --jobs 4 --without development test

# SECONDS STAGE
FROM ruby:${RUBY_VERSION}-slim-buster

ARG RAILS_ROOT
ARG RAILS_ENV
ARG BUNDLER_VERSION

ENV TZ=Asia/Krasnoyarsk
ENV LANG ru_RU.UTF-8
ENV LANGUAGE ru_RU:ru
ENV LC_ALL ru_RU.UTF-8
ENV RAILS_ENV ${RAILS_ENV}

ENV DEBIAN_FRONTEND noninteractive

# Install dependencies
RUN apt-get update -qq && apt-get install -yq --no-install-recommends \
    locales \
    tzdata \
    default-libmysqlclient-dev \
  && apt-get clean \
  && rm -rf /var/cache/apt/archives/* \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log

# Set RU locale
RUN sed -i -e 's/# ru_RU.UTF-8 UTF-8/ru_RU.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure locales && \
    update-locale LANG=ru_RU.UTF-8 && \
    locale-gen ru_RU.UTF-8 && \
    dpkg-reconfigure locales

# Create app folder
RUN mkdir -p ${RAILS_ROOT}
WORKDIR ${RAILS_ROOT}

# Install bundler
RUN gem install bundler:${BUNDLER_VERSION}

# Copy files
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /app/public /app/public
COPY . .

RUN mkdir -p tmp/pids

STOPSIGNAL SIGTERM
