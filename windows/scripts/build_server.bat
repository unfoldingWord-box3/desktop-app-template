@echo off
call .\clean.bat
if not exist ..\..\local_server\target\release\local_server.exe (
    echo "Building local server"
    cd ..\..\local_server
    cargo build --release
    cd ..\windows\scripts
)
if not exist ..\build (
  echo "Assembling build environment"
  node build.js
)
