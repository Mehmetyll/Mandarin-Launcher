# Mandarin-Starter

A PowerShell starter script that automatically sets up and launches [Mandarin-Tool](https://github.com/Mehmetyll/Mandarin-Tool).

## What it does

1. **Language Selection** — Choose between English and Turkish
2. **Java Check** — Detects if Java 21+ is installed on your system
3. **JDK 21 Auto-Install** — If Java is missing or outdated, downloads and silently installs Oracle JDK 21
4. **Download Mandarin-Tool** — Fetches the latest `MandarinTool.jar` from GitHub Releases to your Downloads folder
5. **Launch as Admin** — Starts Mandarin-Tool with Administrator privileges (UAC prompt)

## Quick Start

Run this command in CMD (as administrator):

```cmd
powershell -Command "Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass; Invoke-Expression (Invoke-RestMethod 'https://raw.githubusercontent.com/Mehmetyll/Mandarin-Launcher/main/Mandarin-Launcher.ps1')"
```

## Support & Feedback
If you encountered any bugs or have feature suggestions, feel free to reach out:

*   **Discord:** `mandalinasslee`