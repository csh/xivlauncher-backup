$logName = "XIVLauncher"
$logSource = "XIVLauncher Backup Script"

# A little brutish, but EventLog cmdlets don't seem to love -ErrorAction SilentlyContinue alone
$ErrorActionPreference = "SilentlyContinue"

$eventLog = Get-EventLog -LogName $logName -Source $logSource
if (-not ($eventLog)) {
    if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Host -ForegroundColor Red "Please run this script as Administrator at least once to enable logging to Event Viewer."
    }
    $eventLog = New-EventLog -LogName $logName -Source $logSource
}

$appData = [Environment]::GetFolderPath([Environment+SpecialFolder]::ApplicationData)
$launcherDir = Join-Path -Path $appData -ChildPath "XIVLauncher"

$pluginConfig = Join-Path -Path $launcherDir -ChildPath "pluginConfigs"
$pluginConfigBackups = Join-Path -Path $launcherDir -ChildPath "pluginConfigsBackup" 

if (-not (Test-Path -Path $pluginConfigBackups)) {
    Write-EventLog -LogName $logName -Source $logSource -EventId 1 -EntryType Information -Message "Creating Backups folder at \"${pluginConfigBackups}\""
    New-Item -Path $pluginConfigBackups -ItemType Directory
}

$output = Join-Path -Path $pluginConfigBackups -ChildPath "pluginConfigs-$(Get-Date -Format "yyyyMMddHHmm").zip"

Write-EventLog -LogName $logName -Source $logSource -EventId 0 -EntryType Information -Message "Attempting to backup pluginConfigs folder" 

$compressError = @()
Compress-Archive -Update -CompressionLevel Optimal -Path $pluginConfig -DestinationPath $output -ErrorAction SilentlyContinue -ErrorVariable +compressError

if ($compressError.Count -gt 0) {
    Write-EventLog -LogName $logName -Source $logSource -EventId 2 -EntryType Error -Message "Failed to create backup: `n $($compressError[0].ToString())"
} else {
    Write-EventLog -LogName $logName -Source $logSource -EventId 0 -EntryType Information -Message "Backup completed successfully"
}
