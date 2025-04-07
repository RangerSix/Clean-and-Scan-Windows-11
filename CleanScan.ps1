<#
.SYNOPSIS
    Automates Disk Cleanup and Windows Defender Quick Scan on Windows 11 with logging.
.DESCRIPTION
    This script performs disk cleanup using a preset configuration (configured via cleanmgr.exe /sageset:1) 
    and then initiates a Windows Defender quick scan. It logs each step for tracking and troubleshooting.
.NOTES
    - Run this script with administrative privileges.
    - Ensure you have run "cleanmgr.exe /sageset:1" previously to configure the cleanup options.
    - Log file will be saved to C:\Logs\AutoMaintenance.log
#>

# ------------------------------
# Setup Logging Functionality
# ------------------------------

# Define the log directory and file
$logDir = "C:\Logs"
if (!(Test-Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir | Out-Null
}
$LogFile = Join-Path $logDir "AutoMaintenance.log"

# Function to write log messages with date/time and level information
function Write-Log {
    param (
        [string]$Message,
        [ValidateSet("INFO", "ERROR", "WARN")] 
        [string]$Level = "INFO"
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "$timestamp [$Level] $Message"
    # Write to the log file and echo to console
    $logMessage | Out-File -FilePath $LogFile -Append
    Write-Host $logMessage
}

Write-Log "Script started."

# ------------------------------
# Disk Cleanup Section
# ------------------------------

Write-Log "Starting Disk Cleanup using the preset configuration..."

try {
    # Run Disk Cleanup using the preset configured with /sageset:1
    Start-Process -FilePath "cleanmgr.exe" -ArgumentList "/sagerun:1" -Wait
    Write-Log "Disk Cleanup completed successfully."
}
catch {
    Write-Log "An error occurred during Disk Cleanup: $_" -Level "ERROR"
}

# Pause briefly before starting the antivirus scan
Start-Sleep -Seconds 2

# ------------------------------
# Windows Defender Quick Scan Section
# ------------------------------

Write-Log "Initiating Windows Defender Quick Scan..."

if (Get-Command -Name Start-MpScan -ErrorAction SilentlyContinue) {
    try {
        Start-MpScan -ScanType QuickScan
        Write-Log "Windows Defender Quick Scan completed successfully."
    }
    catch {
        Write-Log "An error occurred during the Windows Defender Quick Scan: $_" -Level "ERROR"
    }
} else {
    Write-Log "Start-MpScan cmdlet is not available on this system. Check that Windows Defender is enabled." -Level "WARN"
}

Write-Log "Script execution completed."