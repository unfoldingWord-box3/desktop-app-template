#!/bin/sh

# Synopsis:
#   getElectronRelease.sh - Downloads and extracts Electron app package for specified architecture
#
# Description:
#   This script downloads an Electron app package from a provided URL and extracts it
#   to a temporary directory. It checks if the package already exists before downloading
#   to avoid duplicate downloads.
#
# Parameters:
#   $1 - downloadUrl: URL to download the Electron package from
#   $2 - arch: Architecture type (e.g., 'arm64' or 'intel64')
#
# Return Values:
#   0 - Success (package downloaded and extracted, or already exists)
#   1 - Error (missing parameters, download failure, or extraction failure)
#


# Check if filename and destination are provided as an argument
if [ -z "$2" ]; then
  echo "Usage: $0 <downloadUrl> <arch>"
  exit 1
fi

# get arguments
downloadUrl="$1"
arch="$2"

testDir="../temp/electron.$arch/Electron.app"
if [ -d "$testDir" ]; then
  echo "Electron.app already exists for $arch"
  exit 0
fi

# Extract filename from URL
filename=${downloadUrl##*/}
echo "filename is $filename"

echo "Fetching for architecture: $arch from $downloadUrl"

# Create directory for downloaded files
destFolder="../temp/electron/$arch"
mkdir -p "$destFolder"

# Download zip file
tempName="$destFolder/temp.zip"
echo "Downloading $arch package to $tempName"
curl -L "$downloadUrl" -o "$tempName"

if [ $? -ne 0 ]; then
    echo "Error: Failed to download $downloadUrl package to $tempName - $?"
    exit 1
fi

# create destination directory
unzipDest="../temp/electron.$arch"
rm -rf "$dest"

# Unzip the file
if ! unzip "$tempName" -d "$unzipDest"; then
  echo "Error: Failed to unzip '$unzipDest'"
  exit 1
fi

echo "Successfully unzipped to: $unzipDest"


    
