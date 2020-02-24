#!/bin/sh

# staging
docker build --cache-from ivvanov1009/explorer:staging \
--tag ivvanov1009/explorer:staging \
--build-arg ADMIN_EMAIL=exp-admin@example.com \
--build-arg ADMIN_PASSWORD=password \
--build-arg AWS_ACCESS_KEY_ID=AKIASRC7TRBPAFJKUZV5 \
--build-arg AWS_S3_BUCKET=backpack.staging.explorer.trekview.org \
--build-arg AWS_S3_BUCKET_REGION=eu-west-2 \
--build-arg AWS_SECRET_ACCESS_KEY=bpasTQGPDbSQwO7wMaeucanWEYBYch5JfK1RNvGV \
--build-arg DATABASE_URL=postgres://trekker:HjO0AdKKEpBytJr01Gzi@staging-explorer-trekview-org.cuoo0iw6cxfx.eu-west-2.rds.amazonaws.com:5432/staging_explorer_trekview_org \
--build-arg DATABASE_HOST=staging-explorer-trekview-org.cuoo0iw6cxfx.eu-west-2.rds.amazonaws.com \
--build-arg DATABASE_NAME=staging_explorer_trekview_org \
--build-arg DATABASE_USER_NAME=trekker \
--build-arg DATABASE_PASSWORD=HjO0AdKKEpBytJr01Gzi \
--build-arg DATABASE_PORT=5432 \
--build-arg DEVISE_SENDER_EMAIL_ADDRESS=staging-explorer@mg.trekview.org \
--build-arg DEVISE_SENDER_NAME="Staging Trek View" \
--build-arg DISALLOW_ALL_WEB_CRAWLERS=true \
--build-arg FOG_DIRECTORY=backpack.staging.explorer.trekview.org \
--build-arg FOG_PROVIDER=AWS \
--build-arg FOG_REGION=eu-west-2 \
--build-arg GOOGLE_ANALYTICS_KEY=UA-136706582-3 \
--build-arg GOOGLE_MAPS_API_KEY=AIzaSyCgi0YaLFIcW7PX4ttlQ8ZZhuVw-xk5a40 \
--build-arg RACK_ENV=staging \
--build-arg RAILS_ENV=staging \
--build-arg MAILCHIMP_AUDIENCE_ID=df129eff24 \
--build-arg MAILCHIMP_API_KEY=a8c9cd3ea520d0f8eba2099c3df0706a-us20 \
--build-arg MAILGUN_DOMAIN=mg.trekview.org \
--build-arg MAILGUN_SMTP_LOGIN=staging-explorer@mg.trekview.org \
--build-arg MAILGUN_SMTP_PASSWORD=a8c58f4bdd5f18b918ce6bd10c19b304-52b6835e-9ec4123e \
--build-arg MAILGUN_SMTP_PORT=587 \
--build-arg MAILGUN_SMTP_SERVER=smtp.mailgun.org \
--build-arg MAILERLITE_API_KEY=3ea2b1dae8091c50d600b41a062694a8 \
--build-arg MAILERLITE_GROUP_ID=92901598 \
--build-arg SECRETE_KEY_BASE=6028b6fd9127cc802a0941f67638d1ede77bdba340abcd88821eca93cfc0ad9c39d87dd8e358975ab5b76195b66262ba2a63f72e105727b1975bd42148a4adce \
--build-arg SITE_URL=staging.explorer.trekview.org \
.

# DATABASE_URL=postgres://trekker:HjO0AdKKEpBytJr01Gzi@staging-explorer-trekview-org.cuoo0iw6cxfx.eu-west-2.rds.amazonaws.com:5432/staging-explorer-trekview-org

# production
docker build --cache-from ivvanov1009/explorer:staging \
--tag ivvanov1009/explorer:production \
--build-arg ADMIN_EMAIL=exp-admin@example.com \
--build-arg ADMIN_PASSWORD=password \
--build-arg AWS_ACCESS_KEY_ID=AKIASRC7TRBPHPLWQLWM \
--build-arg AWS_S3_BUCKET=backpack.explorer.trekview.org \
--build-arg AWS_S3_BUCKET_REGION=eu-west-2 \
--build-arg AWS_SECRET_ACCESS_KEY=tvWZV1CJlJYL7X1oHLCPLQBIBq41sWxR5P8Lpge1 \
--build-arg DATABASE_URL=postgres://trekker:Qh3Ra7cXsxHSVEfCp4MC@explorer-trekview-org.cuoo0iw6cxfx.eu-west-2.rds.amazonaws.com:5432/explorer_trekview_org \
--build-arg DATABASE_HOST=explorer-trekview-org.cuoo0iw6cxfx.eu-west-2.rds.amazonaws.com \
--build-arg DATABASE_NAME=explorer_trekview_org \
--build-arg DATABASE_USER_NAME=trekker \
--build-arg DATABASE_PASSWORD=Qh3Ra7cXsxHSVEfCp4MC \
--build-arg DATABASE_PORT=5432 \
--build-arg DEVISE_SENDER_EMAIL_ADDRESS=explorer@mg.trekview.org \
--build-arg DEVISE_SENDER_NAME="Trek View" \
--build-arg DISALLOW_ALL_WEB_CRAWLERS=true \
--build-arg FOG_DIRECTORY=backpack.explorer.trekview.org \
--build-arg FOG_PROVIDER=AWS \
--build-arg FOG_REGION=eu-west-2 \
--build-arg GOOGLE_ANALYTICS_KEY=UA-136706582-2 \
--build-arg GOOGLE_MAPS_API_KEY=AIzaSyCgi0YaLFIcW7PX4ttlQ8ZZhuVw-xk5a40 \
--build-arg RACK_ENV=production \
--build-arg RAILS_ENV=production \
--build-arg MAILCHIMP_AUDIENCE_ID=df129eff24 \
--build-arg MAILCHIMP_API_KEY=a8c9cd3ea520d0f8eba2099c3df0706a-us20 \
--build-arg MAILGUN_DOMAIN=mg.trekview.org \
--build-arg MAILGUN_SMTP_LOGIN=explorer@mg.trekview.org \
--build-arg MAILGUN_SMTP_PASSWORD=aded54223b5edda9d2c6a413f3926be9-f696beb4-a22e623e \
--build-arg MAILGUN_SMTP_PORT=587 \
--build-arg MAILGUN_SMTP_SERVER=smtp.mailgun.org \
--build-arg MAILERLITE_API_KEY=3ea2b1dae8091c50d600b41a062694a8 \
--build-arg MAILERLITE_GROUP_ID=92901624 \
--build-arg SECRETE_KEY_BASE=6028b6fd9127cc802a0941f67638d1ede77bdba340abcd88821eca93cfc0ad9c39d87dd8e358975ab5b76195b66262ba2a63f72e105727b1975bd42148a4adce \
--build-arg SITE_URL=explorer.trekview.org \
.
