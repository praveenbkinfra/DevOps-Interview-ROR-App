FROM ruby:3.2.2-slim

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs shared-mime-info curl npm
RUN npm install -g yarn
RUN mkdir -p /var/app
WORKDIR /var/app

# Copy dependency files first for better layer caching
COPY Gemfile Gemfile.lock ./
RUN gem install bundler
RUN bundle install --jobs 20 --retry 5

# Copy application code
COPY . .

# Precompile assets
RUN bundle exec rails assets:precompile

# Copy and setup entrypoint
COPY docker/app/entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

EXPOSE 3000
ENTRYPOINT ["entrypoint.sh"]
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
