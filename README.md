# Mandalin-Launcher

A PowerShell starter script that automatically sets up and launches [Mandalin-Tool](https://github.com/Mehmetyll/Mandalin-Tool).

## What it does

1. **Language Selection** — Choose between English and Turkish
2. **Java Check** — Detects if Java 21+ is installed on your system
3. **JDK 21 Auto-Install** — If Java is missing or outdated, downloads and silently installs Oracle JDK 21
4. **Download Mandalin-Tool** — Fetches the latest `MandalinTool.jar` from GitHub Releases to your Downloads folder
5. **Launch as Admin** — Starts Mandalin-Tool with Administrator privileges (UAC prompt)

## Quick Start

Run this command in CMD (as administrator):

```cmd
powershell -Command "Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass; Invoke-Expression (Invoke-RestMethod 'https://raw.githubusercontent.com/Mehmetyll/Mandalin-Launcher/main/Mandalin-Launcher.ps1')"
```

## Support & Feedback
If you encountered any bugs or have feature suggestions, feel free to reach out:

*   **Discord:** `mandalinasslee`
