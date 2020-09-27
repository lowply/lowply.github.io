FROM ruby:alpine
MAINTAINER Sho Mizutani <lowply@gmail.com>
WORKDIR /home
RUN apk add --no-cache bash build-base libxml2-dev libxslt-dev
RUN gem install jekyll -- --use-system-libraries
