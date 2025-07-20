#!/bin/sh
set -e

echo "Environment: ${RAILS_ENV:-development}"

# Only run database operations if not in production or if explicitly requested
if [ "${RAILS_ENV}" != "production" ] || [ "${RUN_DB_SETUP}" = "true" ]; then
  echo "Setting up database..."

  # Wait for database to be ready
  until bundle exec rails runner "ActiveRecord::Base.connection.execute('SELECT 1')" >/dev/null 2>&1; do
    echo "Waiting for database..."
    sleep 2
  done

  echo "Database is ready!"

  # Run database setup
  bundle exec rails db:create || echo "Database already exists"
  bundle exec rails db:migrate

  # Load schema if in development/test
  if [ "${RAILS_ENV}" != "production" ]; then
    bundle exec rails db:schema:load 2>/dev/null || echo "Schema load skipped"
  fi
fi

# Remove any existing PID file
if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

echo "Starting Rails application..."
exec "$@"
