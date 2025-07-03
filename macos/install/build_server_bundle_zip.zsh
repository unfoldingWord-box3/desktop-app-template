#!/usr/bin/env zsh

if [ ! -f ../../local_server/target/release/local_server ]; then
    echo "Building local server"
    cd ../../local_server
    OPENSSL_STATIC=yes cargo build --release
    cd ../macos/scripts
fi

if [ ! -d ../build ]; then
  echo "Assembling build environment"
  node ./build.js
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
  # Use lower case app name in filename
  APP_NAME=${APP_NAME:l}
  # Replace spaces with a dash (-) in filename
  APP_NAME=${APP_NAME// /-}
  # Make executable and zip
  chmod +x $APP_NAME.zsh
  zip -r ../../releases/macos/$APP_NAME-macos-$APP_VERSION.zip * -x "appLauncher.sh" &> /dev/null
  cd ../scripts
fi
