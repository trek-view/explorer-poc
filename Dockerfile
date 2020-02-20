######################
# Stage: Builder
FROM ruby:2.6.2-alpine as Builder

ARG BUNDLE_WITHOUT
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

ENV BUNDLE_WITHOUT ${BUNDLE_WITHOUT}
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
ENV RAILS_SERVE_STATIC_FILES=true


RUN export

RUN apk add --update --no-cache \
    build-base \
    postgresql-dev \
    git \
    imagemagick \
    nodejs-current \
    yarn \
    python2 \
    tzdata

WORKDIR /app

# Install gems
ADD Gemfile* /app/
RUN bundle config --global frozen 1 \
 && bundle install -j4 --retry 3 \
 # Remove unneeded files (cached *.gem, *.o, *.c)
 && rm -rf /usr/local/bundle/cache/*.gem \
 && find /usr/local/bundle/gems/ -name "*.c" -delete \
 && find /usr/local/bundle/gems/ -name "*.o" -delete

# Install yarn packages
COPY package.json yarn.lock .yarnclean /app/
RUN yarn install

# Add the Rails app
ADD . /app

# Precompile assets
RUN bundle exec rake assets:precompile

# Remove folders not needed in resulting image
RUN rm -rf $FOLDERS_TO_REMOVE

###############################
# Stage Final
FROM ruby:2.6.2-alpine
LABEL maintainer="mail@georg-ledermann.de"

ARG ADDITIONAL_PACKAGES
ARG EXECJS_RUNTIME

# Add Alpine packages
RUN apk add --update --no-cache \
    postgresql-client \
    imagemagick \
    $ADDITIONAL_PACKAGES \
    tzdata \
    file

# Add user
RUN addgroup -g 1000 -S app \
 && adduser -u 1000 -S app -G app
USER app

# Copy app with gems from former build stage
COPY --from=Builder /usr/local/bundle/ /usr/local/bundle/
COPY --from=Builder --chown=app:app /app /app

# Set Rails env
ENV RAILS_LOG_TO_STDOUT true
ENV RAILS_SERVE_STATIC_FILES true
ENV EXECJS_RUNTIME $EXECJS_RUNTIME

WORKDIR /app

# Expose Puma port
EXPOSE 3000

# Save timestamp of image building
RUN date -u > BUILD_TIME

# Start up
CMD ["docker/startup.sh"]
