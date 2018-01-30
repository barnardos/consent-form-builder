FROM ruby:2.4.1

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev wget

ENV YARN_VERSION 0.27.5
ENV DOCKERIZE_VERSION v0.5.0
ENV NPM_CONFIG_LOGLEVEL info

# Dockerize - lets you wait for a service to launch before issuing a command
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

# Install Node and Yarn with up to date releases

# Yarn
RUN apt-get install apt-transport-https
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update
RUN apt-get install -y nodejs yarn

# Setup project
RUN mkdir /myapp
WORKDIR /myapp
ADD Gemfile /myapp/Gemfile
ADD Gemfile.lock /myapp/Gemfile.lock
ADD .ruby-version /myapp/.ruby-version
ADD package.json /myapp/package.json
ADD yarn.lock /myapp/yarn.lock
RUN bundle install
RUN yarn install

ADD . /myapp

EXPOSE 3000

# Start the web app
CMD bundle exec puma -t 5:5 -p 3000 -e development
