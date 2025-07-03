#!/usr/bin/env zsh

# This script uses the APP_VERSION and APP_NAME environment variables as defined in app_config.env

# run from pankosmia/[this-repo's-name]/macos/install directory by: ./build_server_bundle_zip.zsh

# Assumes app_setup.zsh has already run; It has in buildMacOS.yml

cd ../../
echo "npm install"
npm install
cd macos/install

source ../../app_config.env

if [ ! -f ../../local_server/target/release/local_server ]; then
    echo "Building local server"
    cd ../../local_server
    OPENSSL_STATIC=yes cargo build --release
    cd ../macos/scripts
fi

# This should be unneccary in gh actions...
if [ -f ../build ]; then
  echo "Removing last build environment"
  rm -rf ../build
fi

echo "Assembling build environment"
node ../scripts/build.js
echo
echo "   **********************************"
echo "   *                                *"
echo "   *           ====                 *"
echo "   * Bundling. Wait for the prompt. *"
echo "   *           ====                 *"
echo "   *                                *"
echo "   **********************************"
echo

cd ../build
# Use lower case app name in filename -- zsh: ${APP_NAME:l}  -- bsh: ${APP_NAME,,}
APP_NAME=${APP_NAME:l}
# Replace spaces with a dash (-) in filename
APP_NAME=${APP_NAME// /-}
# Make executable and zip
chmod +x $APP_NAME.zsh
zip -r ../../releases/macos/$APP_NAME-macos-$APP_VERSION.zip * &> /dev/null
cd ../scripts
