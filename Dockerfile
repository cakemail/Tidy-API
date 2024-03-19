FROM ruby:3.0-bullseye as base

MAINTAINER sebastien@cakemail.com

ENV DEBIAN_FRONTEND noninteractive
ENV PROJECT_PATH /opt/cakemail/sinatra-apps/tidy

# Update package index and install required packages
RUN apt-get update && apt-get install -y \
  apache2 \
  libapache2-mod-passenger \
  git \
  rsyslog \
  supervisor \
  libxml2-dev \
  libxslt1-dev

# Set the working directory in the container
WORKDIR $PROJECT_PATH

# Copy only the Gemfile and Gemfile.lock to leverage Docker cache
COPY Gemfile Gemfile.lock ./

# Install Ruby dependencies
RUN gem install bundler:1.17.2
RUN bundle install

# Copy the rest of the application code into the container
COPY . .


# Expose the port on which your Sinatra application runs
EXPOSE 4567

# Run the server specified in main.rb when the container launches
CMD ["ruby", "main.rb"]
