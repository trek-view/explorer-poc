FROM ruby:2.6.3-alpine AS base

ARG DATABASE_URL
ARG SECRETE_KEY_BASE=foo
ARG DATABASE_HOST
ARG DATABASE_NAME=explorer
ARG DATABASE_USER_NAME
ARG DATABASE_PASSWORD
ARG DATABASE_PORT
ARG ADMIN_EMAIL=exp-admin@example.com
ARG ADMIN_PASSWORD=password
ARG AWS_ACCESS_KEY_ID=AKIASRC7TRBPJAHAXFWK
ARG AWS_S3_BUCKET=backpack-staging-explorer-trekview-org
ARG AWS_S3_BUCKET_REGION=eu-west-2
ARG AWS_SECRET_ACCESS_KEY=HU6GWUcURyrNhea8s2fhdrx4IHA0jONp1I3wGMN2
ARG DEVISE_SENDER_EMAIL_ADDRESS=staging@mg.trekview.org
ARG DEVISE_SENDER_NAME='Trek View Staging'
ARG FOG_DIRECTORY=backpack-staging-explorer-trekview-org
ARG FOG_PROVIDER=AWS
ARG FOG_REGION=eu-west-2
ARG GOOGLE_ANALYTICS_KEY=UA-136706582-3
ARG GOOGLE_MAPS_API_KEY=AIzaSyCgi0YaLFIcW7PX4ttlQ8ZZhuVw-xk5a40
ARG LANG=en_US.UTF-8
ARG MAILCHIMP_AUDIENCE_ID=df129eff24
ARG RACK_ENV=staging
ARG RAILS_ENV=staging
ARG SITE_URL=localhost:3000
ARG DISALLOW_ALL_WEB_CRAWLERS=true
ARG MAILCHIMP_API_KEY=a8c9cd3ea520d0f8eba2099c3df0706a-us20
ARG MAILGUN_DOMAIN=mg.trekview.org
ARG MAILGUN_SMTP_LOGIN=staging@mg.trekview.org
ARG MAILGUN_SMTP_PASSWORD=6e1bbf20c1b47ba32878af36bc76bfdc-816b23ef-aa95db1b
ARG MAILGUN_SMTP_PORT=587
ARG MAILGUN_SMTP_SERVER=smtp.mailgun.org


ENV DATABASE_URL ${DATABASE_URL}
ENV SECRETE_KEY_BASE ${SECRETE_KEY_BASE}
ENV DATABASE_HOST ${DATABASE_HOST}
ENV DATABASE_NAME ${DATABASE_NAME}
ENV DATABASE_USER_NAME ${DATABASE_USER_NAME}
ENV DATABASE_PASSWORD ${DATABASE_PASSWORD}
ENV DATABASE_PORT ${DATABASE_PORT}
ENV ADMIN_EMAIL ${ADMIN_EMAIL}
ENV ADMIN_PASSWORD ${ADMIN_PASSWORD}
ENV AWS_ACCESS_KEY_ID ${AWS_ACCESS_KEY_ID}
ENV AWS_S3_BUCKET ${AWS_S3_BUCKET}
ENV AWS_S3_BUCKET_REGION ${AWS_S3_BUCKET_REGION}
ENV AWS_SECRET_ACCESS_KEY ${AWS_SECRET_ACCESS_KEY}
ENV DEVISE_SENDER_EMAIL_ADDRESS ${DEVISE_SENDER_EMAIL_ADDRESS}
ENV DEVISE_SENDER_NAME ${DEVISE_SENDER_NAME}
ENV FOG_DIRECTORY ${FOG_DIRECTORY}
ENV FOG_PROVIDER ${FOG_PROVIDER}
ENV FOG_REGION ${FOG_REGION}
ENV GOOGLE_ANALYTICS_KEY ${GOOGLE_ANALYTICS_KEY}
ENV GOOGLE_MAPS_API_KEY ${GOOGLE_MAPS_API_KEY}
ENV LANG ${LANG}
ENV MAILCHIMP_AUDIENCE_ID ${MAILCHIMP_AUDIENCE_ID}
ENV RACK_ENV ${RACK_ENV}
ENV RAILS_ENV ${RAILS_ENV}
ENV SITE_URL ${SITE_URL}
ENV DISALLOW_ALL_WEB_CRAWLERS ${DISALLOW_ALL_WEB_CRAWLERS}
ENV MAILCHIMP_API_KEY ${MAILCHIMP_API_KEY}
ENV MAILGUN_DOMAIN ${MAILGUN_DOMAIN}
ENV MAILGUN_SMTP_LOGIN ${MAILGUN_SMTP_LOGIN}
ENV MAILGUN_SMTP_PASSWORD ${MAILGUN_SMTP_PASSWORD}
ENV MAILGUN_SMTP_PORT ${MAILGUN_SMTP_PORT}
ENV MAILGUN_SMTP_SERVER ${MAILGUN_SMTP_SERVER}

RUN export

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
FROM base AS staging

ENV RAILS_ENV staging

RUN gem install bundler -v '2.0.2'
RUN bundle install

ADD . /app
COPY ./config/credentials.yml.enc /app/config/credentials.yml

CMD bundle exec rails s

#
# Production stage
#
FROM base AS production

# Add the rest of the app
ADD . /app
COPY ./config/credentials.yml.enc /app/config/credentials.yml

ENV RAILS_ENV production
ENV NODE_ENV production

# Build assets - n.b. the DATABASE_URL doesn't need to be valid, it's just to
# stop Rails complaining and saying that it isn't set
# RUN bundle exec rake assets:precompile

EXPOSE 3000

CMD ["/app/bin/prod-start.sh"]
