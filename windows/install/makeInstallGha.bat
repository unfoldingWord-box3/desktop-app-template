@echo off
REM run from pankosmia\[this-repo's-name]\windows\install\makeInstallGha.bat
REM This script requires the APP_VERSION and APP_NAME environment variables to be defined in app_config.env

REM This pulls app_config.env into environment variables, to ensure they are accessible by makeInstall.iss when it is called next in gh actions
for /F "tokens=1,2 delims==" %%A in (..\..\app_config.env) do set %%A=%%B

REM Remove single quotes from around APP_NAME
SET APP_NAME=%APP_NAME:'=%

ECHO App Name is: %APP_NAME%
ECHO Version is: %APP_VERSION%
