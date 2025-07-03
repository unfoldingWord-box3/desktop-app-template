#!/bin/sh

# This script uses the APP_VERSION and APP_NAME environment variables as defined in app_config.env
source ../../app_config.env

# requires shc - do `brew install shc`

# Confirm both APP_VERSION and APP_NAME environment variables are set
if [ \( -z "$APP_VERSION" \) -o \( -z "$APP_NAME" \) ]; then

    if [ -z "$APP_VERSION" ]; then
      echo "Error: APP_VERSION environment variable is not set."
    fi

    if [ -z "$APP_NAME" ]; then
      echo "Error: APP_NAME environment variable is not set."
    fi

    exit 1
fi

# Use lower case app name in filename
FILE_APP_NAME=${APP_NAME:l}
# Replace spaces with a dash (-) in filename
FILE_APP_NAME=${APP_NAME// /-}
# Set FILE_APP_NAME environment variable
export FILE_APP_NAME="$FILE_APP_NAME"

arch="$1"

rm -f ../../releases/macos/${FILE_APP_NAME}-installer-*.pkg

cd ../build || exit 1

########################################
# build folder structure for package

# Turn on command echo
set -x

rm -rf ../project

mkdir -p ../project/payload/${FILE_APP_NAME}.app/Contents/MacOS

# convert shell script to app
#rm -f ../build/appLauncher.sh.x.c
#shc -f ../buildResources/appLauncher.sh -o ../project/payload/${FILE_APP_NAME}.app/Contents/MacOS/start-${FILE_APP_NAME}
#chmod 555 ../project/payload/${FILE_APP_NAME}.app/Contents/MacOS/start-${FILE_APP_NAME}

cp ../build/appLauncher.sh ../project/payload/${FILE_APP_NAME}.app/Contents/MacOS/start-${FILE_APP_NAME}.sh

mkdir -p ../project/payload/${FILE_APP_NAME}.app/Contents/Resources
cp ../buildResources/README.md ../project/payload/${FILE_APP_NAME}.app/Contents/Resources/README.md

# add APP_VERSION to Info.plist
cp ../buildResources/Info.plist ../project/payload/${FILE_APP_NAME}.app/Contents/
PLIST_FILE="../project/payload/${FILE_APP_NAME}.app/Contents/Info.plist"

# Check if the file exists
if [ ! -f "$PLIST_FILE" ]; then
    echo "Error: $PLIST_FILE does not exist."
    exit 1
fi

# Replace all occurrences of ${APP_VERSION} with the value of the APP_VERSION variable
sed -i.bak "s/\${APP_VERSION}/$APP_VERSION/g" "$PLIST_FILE"

# Print success message
echo "Replaced \${APP_VERSION} with \"$APP_VERSION\" in $PLIST_FILE."
#echo "Backup of original file saved as $PLIST_FILE.bak"
#remove backup
rm "$PLIST_FILE.bak"

cp -R ./bin ../project/payload/${FILE_APP_NAME}.app/Contents/
chmod 755 ../project/payload/${FILE_APP_NAME}.app/Contents/bin/server.bin

cp -R ./lib ../project/payload/${FILE_APP_NAME}.app/Contents/

mkdir -p ../project/scripts
cp ../install/post_install_script.sh ../project/scripts/postinstall
chmod +x ../project/scripts/postinstall

# maintain a one-off identifier for simpler upgrades of early test releases
if [ "$FILE_APP_NAME" == "liminal" ] then;
  IDENTIFIER="com.yourdomain.liminal"
else
  IDENTIFIER="pankosmia.${FILE_APP_NAME}"
fi

# build pkg
cd ..
pkgbuild \
  --root ./project/payload \
  --scripts ./project/scripts \
  --identifier ${IDENTIFIER} \
  --version "$APP_VERSION" \
  --install-location /Applications \
  ./build/${FILE_APP_NAME}-installer-${arch}_${APP_VERSION}.pkg

# copy to releases folder
cp ./build/${FILE_APP_NAME}-installer-${arch}_${APP_VERSION}.pkg ../releases/macos/