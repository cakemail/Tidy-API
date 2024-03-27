FROM ruby:3.0-bullseye as base

MAINTAINER sebastien@cakemail.com

ENV DEBIAN_FRONTEND noninteractive
ENV PROJECT_PATH /opt/cakemail/sinatra-apps/tidy

RUN apt-get update && apt-get install \
  apache2 \
  libapache2-mod-passenger \
  git \
  python3-pip \
  sudo \
  libxml2-dev \
  libxslt1-dev -y

RUN pip install boto
RUN pip install requests

RUN gem install bundler:2.5.7
RUN gem install passenger

# configure apache
ADD docker/config/apache2/tidy.conf /etc/apache2/sites-available/tidy.conf
RUN a2dissite 000-default && a2enmod rewrite && a2enmod headers && a2ensite tidy.conf

# deploy user
RUN useradd -u 1050 -G www-data -m -d /home/cake cake

# prepare directories
RUN mkdir -p ${PROJECT_PATH} && chown -R cake:cake ${PROJECT_PATH}

ADD . ${PROJECT_PATH}

# Change ownership of project directory
RUN chown -R cake:cake ${PROJECT_PATH}

# Switch to the cake user and run bundle install
WORKDIR ${PROJECT_PATH}
RUN bundle config set deployment false
RUN bundle install --quiet --full-index

# start apache web server
CMD ["/bin/bash", "-c", "source /etc/apache2/envvars && exec /usr/sbin/apache2 -DFOREGROUND"]
