# This script uses the APP_VERSION environment variable as defined in app_config.env

# This script is meant for use with gh action runner, and does not confirm the server is off because it is a new run each time.
# It is run from pankosmia\[this-repo's-name]\windows\install directory in powershell by:  .\bundle_exe.ps1

# Assumes app_setup.bat and install_this_repo.bat have already run; They have in buildWindowsX64.yml
# It is run from pankosmia\[this-repo's-name]\windows\scripts directory in powershell by:  .\bundle_zip.ps1

# This script (the .\makeInstall.bat part) uses the APP_VERSION environment variable as defined in app_config.env

get-content ..\..\app_config.env | foreach {
  $name, $value = $_.split('=')
  if ([string]::IsNullOrWhiteSpace($name) -or $name.Contains('#')) {
    # skip empty or comment line in ENV file
    return
  }
  Set-Variable -Name $name -Value $value
}
# Use lower case app name in filename and replace spaces with dashes (-) and remove single apostrophes (')
$env:FILE_APP_NAME = $APP_NAME.ToLower().Replace(" ","-").Replace("'","")

# Ths shouldn't happen in gh actions as the runner would have just built the server
If (-Not (Test-Path ..\..\local_server\target\release\local_server.exe)) {
  echo "`n"
  echo "   ***************************************************************"
  echo "   * IMPORTANT: Build the local server, then re-run this script! *"
  echo "   ***************************************************************"
  echo "`n"
  exit
}

cd ..\..\
# Ths shouldn't happen in gh actions as the runner would have just built the server
If (Test-Path releases\windows\*.exe) {
  echo "A previous windows .exe release exists. Removing..."
  Remove-Item releases\windows\*.exe
}

# Assumes build_server_wo_clean.bat has just been run.
cd windows\install
echo "Making .exe installer..."
.\makeInstall.bat
