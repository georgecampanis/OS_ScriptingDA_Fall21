

$principal = New-ScheduledTaskPrincipal -UserID "SYSTEM" -LogonType ServiceAccount -RunLevel Highest
$Sta = New-ScheduledTaskAction -Execute "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" –Argument '-ExecutionPolicy Bypass -Command "C:\Project\passingpara.ps1 -firstname Billy -lastname Bob; exit $LASTEXITCODE"'
$Stt = New-ScheduledTaskTrigger -Once -At $(get-date)-RepetitionInterval $([timespan]::FromMinutes("1"))

Register-ScheduledTask TaskTest1 -Action $Sta -Trigger $Stt -Principal $principal
# NOTE:
#-ExecutionPolicy Bypass is used to ensure you have the correct rights to execute the ps1 script file. 
# -Command  is used to point to the script file and accepts the 3 parameters. 
# exit $LASTEXITCODE just ensures that the Task Schedular updates the success/fail codes in the GUI.

