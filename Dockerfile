FROM ruby:2.6-rc
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev sqlite3 && curl -sL https://deb.nodesource.com/setup_10.x | bash - && apt-get install -y nodejs
RUN mkdir /myapp
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
COPY . /myapp