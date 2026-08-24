; ArchitectDrawing installer (Inno Setup)
; -----------------------------------------------------------------------------
; PER-USER install (no admin / no UAC) so the launcher can self-update without elevation.
; It installs ONLY the stable launcher + its config; the launcher fetches, verifies (ed25519 +
; sha256), and installs the actual app on first run from the public release endpoint. App updates
; thereafter flow through the launcher — the installer rarely needs to change.
;
; Build:
;   ISCC ArchitectDrawing.iss
;     expects appliance-launcher.exe and launcher.json next to this .iss, OR override:
;   ISCC /DLauncherSrc="C:\mcp\appliance-launcher\target\release\appliance-launcher.exe" ^
;        /DConfigSrc="launcher.json" ArchitectDrawing.iss

#define AppName        "Architect Drawing"
#define AppVersion     "1.0.0"           ; installer/launcher version (app versions are the launcher's job)
#define AppPublisher   "Symbionica"
#define LauncherExe    "appliance-launcher.exe"

#ifndef LauncherSrc
  #define LauncherSrc  "appliance-launcher.exe"
#endif
#ifndef ConfigSrc
  #define ConfigSrc    "launcher.json"
#endif

[Setup]
AppId={{B7E4B0A2-1C3D-4E5F-9A8B-2C4D6E8F0A12}
AppName={#AppName}
AppVersion={#AppVersion}
AppPublisher={#AppPublisher}
; --- per-user, no elevation ---
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog
DefaultDirName={localappdata}\ArchitectDrawing
DefaultGroupName={#AppName}
DisableProgramGroupPage=yes
DisableDirPage=auto
UninstallDisplayName={#AppName}
UninstallDisplayIcon={app}\{#LauncherExe}
OutputBaseFilename=ArchitectDrawing-Setup
OutputDir=Output
Compression=lzma2
SolidCompression=yes
WizardStyle=modern

[Tasks]
Name: "desktopicon"; Description: "Create a desktop shortcut"; GroupDescription: "Additional icons:"

[Files]
; The stable launcher.
Source: "{#LauncherSrc}"; DestDir: "{app}"; DestName: "{#LauncherExe}"; Flags: ignoreversion
; The launcher config — placed only if absent, so an upgrade preserves the customer's settings.
Source: "{#ConfigSrc}"; DestDir: "{app}"; DestName: "launcher.json"; Flags: onlyifdoesntexist

[Icons]
Name: "{group}\{#AppName}"; Filename: "{app}\{#LauncherExe}"
Name: "{userdesktop}\{#AppName}"; Filename: "{app}\{#LauncherExe}"; Tasks: desktopicon

[Run]
; Offer to start after install; the launcher then fetches + launches the latest app version.
; (Requires a published release at the endpoint; before the first release it will report that and exit.)
Filename: "{app}\{#LauncherExe}"; Description: "Launch {#AppName}"; Flags: nowait postinstall skipifsilent

[UninstallDelete]
; Remove installed app versions + the selection pointer. NOTE: `cfg\` (the user's Claude login/profile)
; is intentionally LEFT in place; delete the install folder manually for a full wipe.
Type: filesandordirs; Name: "{app}\versions"
Type: files; Name: "{app}\current"
