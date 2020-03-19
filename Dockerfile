FROM ruby:2.7

# replace shell with bash so we can source files
# RUN rm /bin/sh && ln -s /bin/bash /bin/sh

WORKDIR /app

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y nodejs yarn postgresql-client

RUN gem install bundler -v 2.1.2
RUN node -v
RUN yarn --verson
RUN ruby -v
RUN bundler version

# Copy the Gemfile as well as the Gemfile.lock and install
# the RubyGems. This is a separate step so the dependencies
# will be cached unless changes to one of those two files
# are made.
COPY Gemfile Gemfile.lock package.json yarn.lock ./

RUN bundle check || bundle install
RUN yarn install --check-files

# Copy the main application.
COPY . ./

ENTRYPOINT ["./entrypoints/docker-entrypoint.sh"]
