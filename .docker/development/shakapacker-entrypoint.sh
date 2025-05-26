#!/bin/bash

set -e

npm install webpack-dev-server@4.15.1 --dev
npm install

exec "$@"
