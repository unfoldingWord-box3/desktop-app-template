#!/usr/bin/env zsh

source ../../app_config.env

set -e
set -u

# set port environment variable
export ROCKET_PORT=19119

if [ -d ../build ]; then
  echo "Removing last build environment"
  rm -rf ../build
fi

if [ ! -d ../build ]; then
  echo "Assembling build environment"
  node ./build.js
fi

echo "Running and Opening Browser..."
cd ../build

# Use lower case app name in filename
APP_NAME=${APP_NAME:l}

chmod +x $APP_NAME.zsh
./$APP_NAME.zsh
