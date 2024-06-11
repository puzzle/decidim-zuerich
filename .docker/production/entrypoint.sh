#!/bin/bash

set -euo pipefail

# Run deface compilation.
if [ "$RAILS_ENV" = "production" ] && [ ! -d "app/compiled_views" ]; then
  SKIP_MEMCACHE_CHECK=1 DEFACE_ENABLED=1 bundle exec rails deface:precompile
else
  echo "Skipping deface compilation because it is already done or not needed."
fi

# Run deface compilation.
if [ "$RAILS_ENV" = "production" ] && [ ! -d "app/compiled_views" ]; then
  SKIP_MEMCACHE_CHECK=1 DEFACE_ENABLED=1 bundle exec rails deface:precompile
else
  echo "Skipping deface compilation because it is already done or not needed."
fi

exec "$@"
