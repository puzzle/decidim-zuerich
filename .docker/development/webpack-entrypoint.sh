#!/bin/bash

set -e

yarn add webpack-dev-server@4.15.1 --dev
yarn install

exec "$@"
