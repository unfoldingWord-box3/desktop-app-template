   [Setup]
   AppName=Liminal
   AppVersion={#GetEnv('APP_VERSION')}
   DefaultDirName={commonpf}\Liminal
   DefaultGroupName=Liminal
   OutputBaseFilename=LiminalSetup_{#GetEnv('APP_VERSION')}
   Compression=lzma
   SolidCompression=yes

   [Files]
   Source: "..\temp\project\payload\Liminal\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs

   [Icons]
   Name: "{group}\Liminal"; Filename: "{app}\appLauncherElectron.bat"
   Name: "{userdesktop}\Liminal"; Filename: "{app}\appLauncherElectron.bat"; Tasks: desktopicon
   Name: "{userdesktop}\Liminal README"; Filename: "{app}\README.txt"; Tasks: desktopicon
   Name: "{group}\Uninstall Liminal (Delete App Files)"; Filename: "{uninstallexe}"; Parameters: "/DELETE /ALLFILES"

   [Run]
   Filename: "{app}\custom_uninstaller.bat"; Parameters: "{app}"

   [Tasks]
   Name: "desktopicon"; Description: "Create a Liminal &desktop icon"; GroupDescription: "Liminal icons:"
