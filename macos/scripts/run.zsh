#!/usr/bin/env zsh

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

echo "Running..."
cd ../build

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
export APP_RESOURCES_DIR="$SCRIPT_DIR/lib/"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
$SCRIPT_DIR/bin/server.bin

