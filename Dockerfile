FROM ruby:2.6.3-alpine AS base

ARG RAILS_ENV
ARG DATABASE_URL

ENV RAILS_ENV ${RAILS_ENV}
ENV DATABASE_URL ${DATABASE_URL}

RUN apk add --no-cache --update build-base \
                                git \
                                postgresql-dev \
                                imagemagick \
                                nodejs \
                                yarn \
                                unzip \
                                tzdata

RUN mkdir /app
WORKDIR /app

# Add the Gemfile and bundle first, so changes to the app don't invalidate the
# cache
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN gem install bundler -v '2.0.2'
RUN bundle install --without development test --deployment

#
# Development stage
#
FROM base AS development
ENV RAILS_ENV development

RUN gem install bundler -v '2.0.2'
RUN bundle install

ADD . /app

CMD bundle exec rails s

#
# Production stage
#
FROM base AS production

# Add the rest of the app
ADD . /app

ENV RAILS_ENV production
ENV NODE_ENV production

# Build assets - n.b. the DATABASE_URL doesn't need to be valid, it's just to
# stop Rails complaining and saying that it isn't set
RUN bundle exec rake assets:precompile DATABASE_URL=postgresql://localhost/

EXPOSE 3000

CMD bin/prod-start
