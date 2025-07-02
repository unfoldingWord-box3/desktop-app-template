#!/bin/bash
# Post-install script for installer

# This script uses the APP_VERSION and APP_NAME environment variables as defined in app_config.env
source ../../app_config.env

# Confirm APP_NAME environment variable is set
if [ -z "$APP_NAME" ]; then
    echo "Error: APP_NAME environment variable is not set."
    exit 1
fi

# Use lower case app name in filename
FILE_APP_NAME=${APP_NAME:l}
# Replace spaces with a dash (-) in filename
FILE_APP_NAME=${APP_NAME// /-}
# Set FILE_APP_NAME environment variable
export FILE_APP_NAME="$FILE_APP_NAME"

# Set install directory to /Applications/${FILE_APP_NAME}.app
INSTALL_DIR="/Applications/${FILE_APP_NAME}.app"

# Ensure the start-${FILE_APP_NAME}.zsh and server.bin scripts are executable
chmod +x "$INSTALL_DIR/Contents/MacOS/start-${FILE_APP_NAME}.sh"
chmod +x "$INSTALL_DIR/Contents/bin/server.bin"

exit 0