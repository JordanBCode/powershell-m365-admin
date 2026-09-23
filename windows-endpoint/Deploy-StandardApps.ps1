<#
.SYNOPSIS
    Deploys standard business software (Chrome, Zoom, Microsoft 365 Apps, Adobe Acrobat Reader)
    and configures a sample Chrome policy.

.DESCRIPTION
    - Designed to be run manually, as Administrator, on any Windows 10/11 PC.
    - Idempotent: each section checks whether the app is already installed
      before attempting install, so re-running won't fail or duplicate work.
    - Logs everything to C:\IT\Logs\Deploy-StandardApps_<timestamp>.log
    - Each app install is wrapped in try/catch so one failure doesn't stop the rest.
    - Built for a real multi-PC deployment scenario in a small IT environment;
      cleaned up here as a portfolio sample (org-specific values replaced with
      placeholders - see NOTES).

.NOTES
    Run as: Right-click PowerShell -> "Run as Administrator" -> execute this script.
    Requires internet access for downloads.

    To adapt for your own environment:
      - $StartPageUrl        : set to your org's intranet/CRM/portal starting page (or remove Section 6 entirely)
      - $ChromeExtensionId   : set to any Chrome extension ID you want force-installed org-wide (or remove Section 5's extension block)
      - Adobe Acrobat section: swap in your org's licensed deployment package path if you use full
        Acrobat rather than Reader (e.g. \\yourserver\yourshare\AcrobatDCUpd.exe /sAll /rs)
#>

#Requires -Version 5.1

# ============================================================
# 0. SETUP - logging, working folders, configurable values
# ============================================================
# NOTE: This script must be run from an Administrator PowerShell session manually.

$WorkDir    = "C:\IT\Deploy"
$LogDir     = "C:\IT\Logs"
$Timestamp  = Get-Date -Format "yyyyMMdd_HHmmss"
$LogFile    = Join-Path $LogDir "Deploy-StandardApps_$Timestamp.log"

# --- Org-specific placeholders: customize these for your environment ---
$StartPageUrl      = "https://example.com"   # page to open in Chrome after deployment (Section 6)
$ChromeExtensionId = ""                       # e.g. "aapocclcgogkmnckokdopfmhonfmgoek" - leave blank to skip

foreach ($dir in @($WorkDir, $LogDir)) {
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
}

function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $line = "[{0}] [{1}] {2}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $Level, $Message
    Write-Host $line
    Add-Content -Path $LogFile -Value $line
}

function Test-AppInstalled {
    <#
        Checks common uninstall registry locations for a matching DisplayName.
        Works without needing to know exact version strings.
    #>
    param([string]$NameMatch)

    $paths = @(
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*"
    )
    foreach ($p in $paths) {
        $found = Get-ItemProperty -Path $p -ErrorAction SilentlyContinue |
                 Where-Object { $_.DisplayName -like "*$NameMatch*" }
        if ($found) { return $true }
    }
    return $false
}

function Get-ODTDownloadUrl {
    <#
        Microsoft deletes old ODT installer files whenever they publish a new version,
        so a hardcoded download.microsoft.com URL goes stale every few months.
        This scrapes the current link off the official download page at run time.
    #>
    $pageUrl = "https://www.microsoft.com/en-us/download/details.aspx?id=49117"
    $headers = @{ "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36" }
    $page = Invoke-WebRequest -Uri $pageUrl -UseBasicParsing -Headers $headers -ErrorAction Stop
    $match = [regex]::Match($page.Content, 'https://download\.microsoft\.com/download/[^"''\s]+officedeploymenttool[^"''\s]+\.exe')
    if (-not $match.Success) { throw "Could not locate current ODT download link on Microsoft's page - page layout may have changed." }
    return $match.Value
}

function Invoke-Download {
    param([string]$Url, [string]$OutFile)
    Write-Log "Downloading: $Url"
    $headers = @{ "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36" }
    Invoke-WebRequest -Uri $Url -OutFile $OutFile -UseBasicParsing -Headers $headers -ErrorAction Stop
}

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Write-Log "===== Deployment started ====="

# ============================================================
# 1. GOOGLE CHROME
# ============================================================
try {
    if (Test-AppInstalled -NameMatch "Google Chrome") {
        Write-Log "Chrome already installed - skipping."
    } else {
        Write-Log "Installing Google Chrome..."
        $chromeInstaller = Join-Path $WorkDir "chrome_installer.exe"
        Invoke-Download -Url "https://dl.google.com/chrome/install/latest/chrome_installer.exe" -OutFile $chromeInstaller
        $proc = Start-Process -FilePath $chromeInstaller -ArgumentList "/silent /install" -Wait -PassThru
        if ($proc.ExitCode -ne 0) { throw "Chrome installer exited with code $($proc.ExitCode)" }
        Write-Log "Chrome installed successfully."
    }
} catch {
    Write-Log "FAILED to install Chrome: $_" "ERROR"
}

# ============================================================
# 2. ZOOM
# ============================================================
try {
    if (Test-AppInstalled -NameMatch "Zoom") {
        Write-Log "Zoom already installed - skipping."
    } else {
        Write-Log "Installing Zoom..."
        $zoomInstaller = Join-Path $WorkDir "ZoomInstallerFull.msi"
        Invoke-Download -Url "https://zoom.us/client/latest/ZoomInstallerFull.msi" -OutFile $zoomInstaller
        $proc = Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$zoomInstaller`" /qn /norestart" -Wait -PassThru
        if ($proc.ExitCode -ne 0 -and $proc.ExitCode -ne 3010) { throw "Zoom installer exited with code $($proc.ExitCode)" }
        Write-Log "Zoom installed successfully."
    }
} catch {
    Write-Log "FAILED to install Zoom: $_" "ERROR"
}

# ============================================================
# 3. MICROSOFT 365 APPS (via Office Deployment Tool)
# ============================================================
try {
    if (Test-AppInstalled -NameMatch "Microsoft 365 Apps") {
        Write-Log "Microsoft 365 Apps already installed - skipping."
    } else {
        Write-Log "Installing Microsoft 365 Apps via ODT..."

        $odtDir    = Join-Path $WorkDir "ODT"
        if (-not (Test-Path $odtDir)) { New-Item -ItemType Directory -Path $odtDir -Force | Out-Null }
        $odtSetup  = Join-Path $odtDir "setup.exe"
        $configXml = Join-Path $odtDir "config.xml"

        # Download the Office Deployment Tool bootstrapper (setup.exe) - link resolved dynamically since it changes with each release
        $odtUrl = Get-ODTDownloadUrl
        Invoke-Download -Url $odtUrl -OutFile (Join-Path $odtDir "odt_setup.exe")
        Start-Process -FilePath (Join-Path $odtDir "odt_setup.exe") -ArgumentList "/quiet /extract:`"$odtDir`"" -Wait

        # Standard config - 64-bit, Current Channel, common desktop apps
        $configContent = @"
<Configuration>
  <Add OfficeClientEdition="64" Channel="Current">
    <Product ID="O365ProPlusRetail">
      <Language ID="en-us" />
    </Product>
  </Add>
  <Updates Enabled="TRUE" Channel="Current" />
  <Display Level="None" AcceptEULA="TRUE" />
</Configuration>
"@
        Set-Content -Path $configXml -Value $configContent -Encoding UTF8

        $proc = Start-Process -FilePath $odtSetup -ArgumentList "/configure `"$configXml`"" -Wait -PassThru
        if ($proc.ExitCode -ne 0) { throw "ODT setup exited with code $($proc.ExitCode)" }
        Write-Log "Microsoft 365 Apps installed successfully."
    }
} catch {
    Write-Log "FAILED to install Microsoft 365 Apps: $_" "ERROR"
}

# ============================================================
# 4. ADOBE ACROBAT READER
# ============================================================
try {
    if (Test-AppInstalled -NameMatch "Adobe Acrobat") {
        Write-Log "Adobe Acrobat already installed - skipping."
    } else {
        Write-Log "Installing Adobe Acrobat Reader via winget..."
        $winget = Get-Command winget.exe -ErrorAction SilentlyContinue
        if ($winget) {
            $proc = Start-Process -FilePath "winget.exe" -ArgumentList "install --id Adobe.Acrobat.Reader.64-bit --silent --accept-package-agreements --accept-source-agreements" -Wait -PassThru
            if ($proc.ExitCode -ne 0) { throw "winget Acrobat install exited with code $($proc.ExitCode)" }
            Write-Log "Adobe Acrobat Reader installed successfully via winget."
        } else {
            throw "winget not available on this PC. For the full (non-Reader) Adobe Acrobat product, use your org's licensed deployment package instead, e.g.: \\yourserver\yourshare\AcrobatDCUpd.exe /sAll /rs"
        }
    }
} catch {
    Write-Log "FAILED to install Adobe Acrobat Reader: $_" "ERROR"
}

# ============================================================
# 5. CHROME POLICY - sample managed policy + optional forced extension
# ============================================================
try {
    Write-Log "Configuring sample Chrome policy (allow pop-ups on all sites)..."

    $chromePolicyPath = "HKLM:\SOFTWARE\Policies\Google\Chrome"
    if (-not (Test-Path $chromePolicyPath)) {
        New-Item -Path $chromePolicyPath -Force | Out-Null
    }

    # DefaultPopupsSetting: 1 = Allow all sites to show pop-ups.
    # Useful when an internal line-of-business web app relies on pop-up windows.
    New-ItemProperty -Path $chromePolicyPath -Name "DefaultPopupsSetting" -Value 1 -PropertyType DWord -Force | Out-Null
    Write-Log "Chrome policy applied: pop-ups/redirects allowed."

    # Optional: force-install a specific Chrome extension org-wide (no user click-through required).
    # Set $ChromeExtensionId at the top of this script to enable; leave blank to skip.
    if ($ChromeExtensionId) {
        $forcelistPath = Join-Path $chromePolicyPath "ExtensionInstallForcelist"
        if (-not (Test-Path $forcelistPath)) { New-Item -Path $forcelistPath -Force | Out-Null }
        New-ItemProperty -Path $forcelistPath -Name "1" -Value "$ChromeExtensionId;https://clients2.google.com/service/update2/crx" -PropertyType String -Force | Out-Null
        Write-Log "Chrome policy applied: extension $ChromeExtensionId force-installed."
    }
} catch {
    Write-Log "FAILED to set Chrome policy: $_" "ERROR"
}

Write-Log "===== Deployment finished. Log saved to $LogFile ====="
Write-Host "`nDone. Review the log for any FAILED entries: $LogFile" -ForegroundColor Cyan

# ============================================================
# 6. LAUNCH CHROME WITH STARTING TAB (optional)
# ============================================================
try {
    $chromeExe = "$env:ProgramFiles\Google\Chrome\Application\chrome.exe"
    if (-not (Test-Path $chromeExe)) { $chromeExe = "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe" }

    if (Test-Path $chromeExe) {
        Write-Log "Launching Chrome to $StartPageUrl..."
        Start-Process -FilePath $chromeExe -ArgumentList $StartPageUrl
    } else {
        Write-Log "Could not locate chrome.exe to launch - skipping." "WARN"
    }
} catch {
    Write-Log "FAILED to launch Chrome: $_" "ERROR"
}
