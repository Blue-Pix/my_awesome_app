FROM ruby:2.6.5
ENV LANG C.UTF-8
ENV TZ Asia/Tokyo
ENV EDITOR vim

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs vim
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt-get install -y nodejs
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update -qq \
    && apt-get install -y nodejs yarn \
    && mkdir /myapp

RUN gem update --system
RUN gem install bundler

WORKDIR /tmp
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN bundle install

ENV APP_HOME /myapp
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME
ADD . $APP_HOME
RUN mkdir -p $APP_HOME/tmp/sockets
RUN mkdir -p $APP_HOME/tmp/pids
