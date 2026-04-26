# ============================================================================
#  Mandarin-Launcher.ps1
#  Launcher script for Mandarin-Tool
#  https://github.com/Mehmetyll/Mandarin-Tool
#  Made by: Mehmet_yl
# ============================================================================

$RequiredMajorVersion  = 21
$JdkInstallerName      = "jdk-21_windows-x64_bin.exe"
$JarName               = "MandarinTool.jar"
$JarDownloadUrl        = "https://github.com/Mehmetyll/Mandarin-Tool/releases/download/Mandarin-Tool/MandarinTool.jar"
$JdkDownloadUrl        = "https://download.oracle.com/java/21/latest/jdk-21_windows-x64_bin.exe"
$JdkInstallDir         = "C:\Program Files\Java\jdk-21"
$DownloadDir           = Join-Path $env:USERPROFILE "Downloads"
$Lang = @{}

$LangEN = @{
    Banner           = "Mandarin-Tool  -  Launcher"
    MadeBy           = "Made by: Mehmet_yl"
    Downloading      = "Downloading"
    CheckingJava     = "Checking system Java installation..."
    JavaFound        = "System Java found: version {0}  ({1})"
    JavaNoVersion    = "Found java.exe but could not determine its version."
    JavaNotFound     = "Java is NOT installed or not found on the system PATH."
    JavaOk           = "System Java {0} meets the minimum requirement (JDK {1})."
    JavaOld          = "System Java {0} is older than the required JDK {1}."
    JdkAlready       = "JDK {0} already installed at: {1}"
    DownloadingJdk   = "Downloading Oracle JDK {0} installer..."
    DownloadDone     = "Download complete. Size: {0} MB"
    DownloadFailed   = "Failed to download JDK {0}."
    InstallingJdk    = "Installing JDK {0} silently (this may take a minute)..."
    UacJdk           = "A UAC prompt may appear for the JDK installer. Please click 'Yes'."
    InstallerCode    = "Installer exited with code {0}."
    JdkInstalled     = "JDK {0} installed successfully."
    JdkInstallFail   = "Failed to install JDK {0}."
    JdkVerified      = "Verified installed JDK: version {0}  ({1})"
    JdkNotFound      = "java.exe not found after installation. Expected location: {0}"
    DownloadingJar   = "Downloading {0} from GitHub Releases..."
    JarDone          = "{0} downloaded successfully. Size: {1} MB"
    JarFailed        = "Failed to download {0}."
    Launching        = "Launching {0} with Administrator privileges..."
    UacJar           = "A UAC prompt will appear. Please click 'Yes' to allow."
    LaunchOk         = "{0} launched successfully!"
    LaunchFail       = "Failed to launch {0}."
    Finished         = "Launcher script finished."
    PressKey         = "Press any key to exit..."
}

$LangTR = @{
    Banner           = "Mandarin-Tool  -  Launcher"
    MadeBy           = "Made by: Mehmet_yl"
    Downloading      = "Indiriliyor"
    CheckingJava     = "Sistem Java kurulumu kontrol ediliyor..."
    JavaFound        = "Sistem Java bulundu: versiyon {0}  ({1})"
    JavaNoVersion    = "java.exe bulundu ancak versiyonu tespit edilemedi."
    JavaNotFound     = "Java yuklu degil veya sistem PATH'inde bulunamadi."
    JavaOk           = "Sistem Java {0} minimum gereksinimi karsilar (JDK {1})."
    JavaOld          = "Sistem Java {0}, gereken JDK {1} surumunden eski."
    JdkAlready       = "JDK {0} zaten kurulu: {1}"
    DownloadingJdk   = "Oracle JDK {0} yukleyicisi indiriliyor..."
    DownloadDone     = "Indirme tamamlandi. Boyut: {0} MB"
    DownloadFailed   = "JDK {0} indirilemedi."
    InstallingJdk    = "JDK {0} sessizce kuruluyor (bu bir dakika surebilir)..."
    UacJdk           = "JDK yukleyicisi icin bir UAC istemi cikabilir. Lutfen 'Evet' secin."
    InstallerCode    = "Yukleyici {0} koduyla cikti."
    JdkInstalled     = "JDK {0} basariyla kuruldu."
    JdkInstallFail   = "JDK {0} kurulamadi."
    JdkVerified      = "Kurulan JDK dogrulandi: versiyon {0}  ({1})"
    JdkNotFound      = "Kurulumdan sonra java.exe bulunamadi. Beklenen konum: {0}"
    DownloadingJar   = "{0} GitHub Releases'dan indiriliyor..."
    JarDone          = "{0} basariyla indirildi. Boyut: {1} MB"
    JarFailed        = "{0} indirilemedi."
    Launching        = "{0} Yonetici yetkileriyle baslatiliyor..."
    UacJar           = "Bir UAC istemi gorunecek. Lutfen 'Evet' secin."
    LaunchOk         = "{0} basariyla baslatildi!"
    LaunchFail       = "{0} baslatilamadi."
    Finished         = "Baslangic scripti tamamlandi."
    PressKey         = "Cikmak icin bir tusa basin..."
}

function L { param([string]$Key) return $Lang[$Key] }

function Write-Status  { param([string]$Message) Write-Host "[*] $Message" -ForegroundColor Cyan    }
function Write-Success { param([string]$Message) Write-Host "[+] $Message" -ForegroundColor Green   }
function Write-Warn    { param([string]$Message) Write-Host "[!] $Message" -ForegroundColor Yellow  }
function Write-Err     { param([string]$Message) Write-Host "[X] $Message" -ForegroundColor Red     }

function Get-FileWithProgress {
    param([string]$Url, [string]$OutFile, [string]$Label)
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    $request = [System.Net.HttpWebRequest]::Create($Url)
    $request.AllowAutoRedirect = $true
    $request.UserAgent = "Mandarin-Launcher/1.0"
    $request.Timeout   = 1800000 

    $response   = $request.GetResponse()
    $totalBytes = $response.ContentLength
    $stream     = $response.GetResponseStream()
    $fileStream = [System.IO.File]::Create($OutFile)

    $buffer      = New-Object byte[] 81920
    $totalRead   = [long]0
    $lastPercent = -1
    $dlWord      = L "Downloading"

    try {
        do {
            $read = $stream.Read($buffer, 0, $buffer.Length)
            if ($read -gt 0) {
                $fileStream.Write($buffer, 0, $read)
                $totalRead += $read

                if ($totalBytes -gt 0) {
                    $pct = [math]::Floor(($totalRead / $totalBytes) * 100)
                    if ($pct -ne $lastPercent) {
                        $lastPercent = $pct
                        $mbDone  = [math]::Round($totalRead  / 1MB, 1)
                        $mbTotal = [math]::Round($totalBytes / 1MB, 1)
                        Write-Host ("`r    {0} {1} ... {2}%  ({3} / {4} MB)   " -f $dlWord, $Label, $pct, $mbDone, $mbTotal) -NoNewline -ForegroundColor DarkCyan
                    }
                }
            }
        } while ($read -gt 0)

        Write-Host ""
    } finally {
        $fileStream.Close()
        $stream.Close()
        $response.Close()
    }
}

function Get-JavaMajorVersion {
    param([string]$JavaExePath)
    try {
        $versionOutput = & "$JavaExePath" -version 2>&1 | Out-String
        if ($versionOutput -match '"(\d+)(\.(\d+))?') {
            $major = [int]$Matches[1]
            if ($major -eq 1 -and $Matches[3]) { $major = [int]$Matches[3] }
            return $major
        }
    } catch {
        return 0
    }
    return 0
}

Clear-Host
Write-Host ""
Write-Host " Mandarin-Tool Launcher" -ForegroundColor White
Write-Host " Made by: Mehmet_yl" -ForegroundColor DarkGray
Write-Host ""
Write-Host " 1) Continue in English" -ForegroundColor Cyan
Write-Host " 2) Turkce devam et" -ForegroundColor Cyan
Write-Host ""

do {
    $choice = Read-Host " Select / Secim [1-2]"
} while ($choice -ne "1" -and $choice -ne "2")

if ($choice -eq "2") {
    $Lang = $LangTR
} else {
    $Lang = $LangEN
}

Write-Host ""
Write-Host ((L "Banner")) -ForegroundColor White
Write-Host ((L "MadeBy")) -ForegroundColor DarkGray
Write-Host ""

# Check system Java
Write-Status (L "CheckingJava")

$systemJava    = $null
$javaExe       = $null
$systemVersion = 0

$javaCmd = Get-Command java -ErrorAction SilentlyContinue
if ($javaCmd) {
    $systemJava    = $javaCmd.Source
    $systemVersion = Get-JavaMajorVersion -JavaExePath $systemJava
    if ($systemVersion -gt 0) {
        Write-Success ((L "JavaFound") -f $systemVersion, $systemJava)
    } else {
        Write-Warn (L "JavaNoVersion")
    }
} else {
    Write-Warn (L "JavaNotFound")
}

# Install JDK 21 if needed
if ($systemVersion -ge $RequiredMajorVersion) {
    Write-Success ((L "JavaOk") -f $systemVersion, $RequiredMajorVersion)
    $javaExe = $systemJava
} else {
    if ($systemVersion -gt 0) {
        Write-Warn ((L "JavaOld") -f $systemVersion, $RequiredMajorVersion)
    }

    $installedJavaExe = Join-Path $JdkInstallDir "bin\java.exe"

    if (Test-Path $installedJavaExe) {
        $installedVersion = Get-JavaMajorVersion -JavaExePath $installedJavaExe
        if ($installedVersion -ge $RequiredMajorVersion) {
            Write-Success ((L "JdkAlready") -f $installedVersion, $JdkInstallDir)
            $javaExe = $installedJavaExe
        }
    }

    if (-not $javaExe) {
        Write-Status ((L "DownloadingJdk") -f $RequiredMajorVersion)

        $installerPath = Join-Path $DownloadDir $JdkInstallerName
        try {
            Get-FileWithProgress -Url $JdkDownloadUrl -OutFile $installerPath -Label "JDK $RequiredMajorVersion"
            Write-Success ((L "DownloadDone") -f ([math]::Round((Get-Item $installerPath).Length / 1MB, 1)))
        } catch {
            Write-Err ((L "DownloadFailed") -f $RequiredMajorVersion)
            Write-Err $_.Exception.Message
            Write-Host ""
            Write-Host (L "PressKey") -ForegroundColor Gray
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
            exit 1
        }

        Write-Status ((L "InstallingJdk") -f $RequiredMajorVersion)
        Write-Warn (L "UacJdk")
        try {
            $installProcess = Start-Process -FilePath $installerPath `
                                            -ArgumentList "/s" `
                                            -Verb RunAs `
                                            -Wait `
                                            -PassThru

            if ($installProcess.ExitCode -ne 0) {
                throw ((L "InstallerCode") -f $installProcess.ExitCode)
            }

            Write-Success ((L "JdkInstalled") -f $RequiredMajorVersion)
        } catch {
            Write-Err ((L "JdkInstallFail") -f $RequiredMajorVersion)
            Write-Err $_.Exception.Message
            Write-Host ""
            Write-Host (L "PressKey") -ForegroundColor Gray
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
            exit 1
        }

        Remove-Item $installerPath -Force -ErrorAction SilentlyContinue
        $foundJdkDir = $null
        $javaBaseDir = "C:\Program Files\Java"
        if (Test-Path $javaBaseDir) {
            $foundJdkDir = Get-ChildItem -Path $javaBaseDir -Directory |
                           Where-Object { $_.Name -match '^jdk-21' } |
                           Sort-Object Name -Descending |
                           Select-Object -First 1
        }

        if ($foundJdkDir) {
            $installedJavaExe = Join-Path $foundJdkDir.FullName "bin\java.exe"
        }

        if (Test-Path $installedJavaExe) {
            $installedVersion = Get-JavaMajorVersion -JavaExePath $installedJavaExe
            Write-Success ((L "JdkVerified") -f $installedVersion, $installedJavaExe)
            $javaExe = $installedJavaExe
        } else {
            Write-Err ((L "JdkNotFound") -f $installedJavaExe)
            Write-Host ""
            Write-Host (L "PressKey") -ForegroundColor Gray
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
            exit 1
        }
    }
}

# Download MandarinTool.jar
$jarPath = Join-Path $DownloadDir $JarName

Write-Status ((L "DownloadingJar") -f $JarName)
try {
    Get-FileWithProgress -Url $JarDownloadUrl -OutFile $jarPath -Label $JarName

    $jarSizeMB = [math]::Round((Get-Item $jarPath).Length / 1MB, 2)
    Write-Success ((L "JarDone") -f $JarName, $jarSizeMB)
} catch {
    Write-Err ((L "JarFailed") -f $JarName)
    Write-Err $_.Exception.Message
    Write-Host ""
    Write-Host (L "PressKey") -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

# Launch MandarinTool.jar as Administrator
Write-Status ((L "Launching") -f $JarName)
Write-Warn (L "UacJar")
Write-Host ""

try {
    $javaArgs = "-jar `"$jarPath`""
    Start-Process -FilePath $javaExe `
                  -ArgumentList $javaArgs `
                  -Verb RunAs `
                  -WorkingDirectory $DownloadDir

    Write-Success ((L "LaunchOk") -f $JarName)
} catch {
    Write-Err ((L "LaunchFail") -f $JarName)
    Write-Err $_.Exception.Message
}

Write-Host ""
Write-Host ((L "Finished")) -ForegroundColor White
Write-Host ""
Write-Host (L "PressKey") -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")