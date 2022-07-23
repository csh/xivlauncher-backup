XIVLauncher Backup Script
=========================

Creates a ZIP file containing all your `pluginConfigs` in `%AppData%\XIVLauncher\pluginConfigsBackup` and logs information to Windows Event Viewer if the script is run as Administrator at least once.

## Automation

You can use the Task Scheduler to automatically run this script periodically, simply [download](https://github.com/csh/xivlauncher-backup/archive/refs/heads/main.zip) the repository, extract the script somewhere you won't accidentally delete it and then setup a task to run the script with the following paramters. 

You can use any schedule that works for you.

### Task Parameters

|Parameter|Value|
|---------|-----|
|`Program/script`|`powershell`|
|`Add arguments (optional)`|`-ExecutionPolicy Bypass .\Create-XIVLauncherBackup.ps1`|
|`Start in (optional)`|`<script folder>`|

If you're comfortable with Powershell, you can run/alter the script below to setup the task for you.

```powershell
$action = New-ScheduledTaskAction -Execute 'powershell' -Argument '-ExecutionPolicy Bypass .\Create-XIVLauncherBackup.ps1' -WorkingDirectory '<script folder>'
$trigger = New-ScheduledTaskTrigger -Daily -At 6pm
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "XIVLauncher\Plugin Configuration Backup" -Description "Backup pluginConfigs folder."
```
