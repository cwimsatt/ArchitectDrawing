# installer/

Inno Setup script that installs the app's launcher per-user (no admin required).

Build (Inno Setup 6+):

```
ISCC ArchitectDrawing.iss
```

Override the launcher source if needed: `ISCC /DLauncherSrc="...\appliance-launcher.exe" ArchitectDrawing.iss`.
The compiled installer lands in `Output/` (gitignored).
