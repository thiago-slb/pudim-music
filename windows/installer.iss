; Pudim installer for Windows (Inno Setup 6). Installs for the current user only, without asking for administrator.
; Generate after `flutter build windows --release`:
;   "C:\Program Files (x86)\Inno Setup 6\ISCC.exe" windows\installer.iss
; Outputs build\installer\PudimMusic-Setup.exe.

#define AppVersion "1.0.0"

[Setup]
AppId={{6F2B8C1E-4D7A-4E5B-9C3F-50D1A7E2B9C4}
AppName=Pudim
AppVersion={#AppVersion}
AppPublisher=Pudim
DefaultDirName={localappdata}\Programs\PudimMusic
DefaultGroupName=Pudim
DisableProgramGroupPage=yes
PrivilegesRequired=lowest
OutputDir=..\build\installer
OutputBaseFilename=PudimMusic-Setup
SetupIconFile=runner\resources\app_icon.ico
UninstallDisplayIcon={app}\pudim_music.exe
Compression=lzma2
SolidCompression=yes
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
CloseApplications=yes

[Languages]
Name: "pt"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"

[Tasks]
Name: "desktopicon"; Description: "Criar atalho na área de trabalho"; Flags: unchecked

[Files]
Source: "..\build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

; Shortcuts with the old name (before it became "Pudim").
[InstallDelete]
Type: files; Name: "{autoprograms}\PudimMusic.lnk"
Type: files; Name: "{autodesktop}\PudimMusic.lnk"

[Icons]
Name: "{autoprograms}\Pudim"; Filename: "{app}\pudim_music.exe"
Name: "{autodesktop}\Pudim"; Filename: "{app}\pudim_music.exe"; Tasks: desktopicon

[Run]
Filename: "{app}\pudim_music.exe"; Description: "Abrir o Pudim"; Flags: nowait postinstall skipifsilent
