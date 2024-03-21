FROM ruby:3.0-bullseye as base

MAINTAINER sebastien@cakemail.com

ENV DEBIAN_FRONTEND noninteractive
ENV PROJECT_PATH /opt/cakemail/sinatra-apps/tidy

# Debian Wheezy sources are now on archive
# RUN sed -i 's/deb.debian.org/archive.debian.org/g' /etc/apt/sources.list
# RUN sed -i 's/security.debian.org/archive.debian.org/g' /etc/apt/sources.list
# RUN sed -i '/wheezy-updates/d' /etc/apt/sources.list

RUN apt-get update && apt-get install \
  apache2 \
  libapache2-mod-passenger \
  git \
  rsyslog \
  supervisor \
  # python-requests \
  # python-boto \
  python3-pip \
  sudo \
  libxml2-dev \
  libxslt1-dev -y

RUN pip install boto
RUN pip install python-requests

RUN gem install bundler:1.17.2

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
# RUN sudo su cake -c "bundle config set --local path 'bundle' && bundle install --quiet"
RUN sudo su cake -c "bundle install --deployment --quiet"

# remote logging
ADD docker/config/rsyslog/remote.conf /etc/rsyslog.d/remote.conf
ADD docker/config/supervisor/supervisord.conf /etc/supervisord.conf

# CMD /usr/bin/supervisord -c /etc/supervisor/supervisord.conf

# RUN sudo chmod 777 /opt/cakemail/sinatra-apps/tidy/public
CMD ["/usr/bin/supervisord"]