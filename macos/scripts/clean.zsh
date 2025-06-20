#!/usr/bin/env zsh

echo
if read -q "choice?Is the server off?[Y/N]? "; then

  if [ -d ../build ]; then
    echo
    echo
    echo "Removing last build environment"
    rm -rf ../build
  fi

  if [ -f ../../local_server/target/release/local_server ]; then
      echo
      echo
      echo "Cleaning local server"
      cd ../../local_server
      cargo clean
      cd ../macos/scripts
  fi

  echo
  echo
  echo "The local server and build environment have been cleaned."
  echo

else
  echo
  echo
  echo "Exiting..."
  echo
  echo "If the server is on, turn it off with Ctrl-C in the terminal window in which it is running, then re-run this script.";
  echo
fi