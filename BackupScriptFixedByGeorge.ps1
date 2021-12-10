$Destination="C:\BkpDest"
$StagingPath="C:\TempBkp\Staging"
$Versions="2" #How many of the last Backups you want to keep
$BackupDirs="C:\Temp", "C:\Temp2" #What Folders you want to backup
$ExcludeDirs="C:\temp\DontBackThisUp","C:\temp\BackThisUp1a"#,

$UseStaging = $true #only if you use ZIP, than we copy file to Staging, zip it and copy the ZIP to destination, like Staging, and to save NetworkBandwith


#Variables, only Change here
#$Destination = "C:\temp\_Backup" #Copy the Files to this Location


#$Backupdirs = "C:\Source1", "C:\Source2" #What Folders you want to backup
#$ExcludeDirs = ($env:SystemDrive + "\Users\.*\AppData\Local"), "C:\Program Files (x86)\Common Files\Adobe" #This list of Directories will not be copied

$logPath = "C:\temp\_Backup"
$LogfileName = "Log" #Log Name
$LoggingLevel = "3" #LoggingLevel only for Output in Powershell Window, 1=smart, 3=Heavy

$Zip = $true #Zip the Backup Destination
$Use7ZIP = $false #7ZIP Module will be installed https://www.powershellgallery.com/packages/7Zip4Powershell/2.0.0


$RemoveBackupDestination = $true #Remove copied files after Zip, only if $Zip is true


#region Functions

function Write-au2matorLog {
    [CmdletBinding()]
    param
    (
        [ValidateSet('DEBUG', 'INFO', 'WARNING', 'ERROR')]
        [string]$Type,
        [string]$Text
    )
       
    # Set logging path
    if (!(Test-Path -Path $logPath)) {
        try {
            $null = New-Item -Path $logPath -ItemType Directory
            Write-Verbose ("Path: ""{0}"" was created." -f $logPath)
        }
        catch {
            Write-Verbose ("Path: ""{0}"" couldn't be created." -f $logPath)
        }
    }
    else {
        Write-Verbose ("Path: ""{0}"" already exists." -f $logPath)
    }
    [string]$logFile = '{0}\{1}_{2}.log' -f $logPath, $(Get-Date -Format 'yyyyMMdd'), $LogfileName
    $logEntry = '{0}: <{1}> <{2}> {3}' -f $(Get-Date -Format dd.MM.yyyy-HH:mm:ss), $Type, $PID, $Text
    
    try { Add-Content -Path $logFile -Value $logEntry }
    catch {
        Start-sleep -Milliseconds 50
        Add-Content -Path $logFile -Value $logEntry
    }
    if ($LoggingLevel -eq "3") { Write-Host $Text }
    
    
}

#endregion Functions

#System Variables, do not change
$PreCheck = $true
$BackUpCheck = $false
$FinalBackupdirs = @()


#SCRIPT
##PRE CHECK
Write-au2matorLog -Type Info -Text "Start the Script"
Write-au2matorLog -Type Info -Text "Create Backup Dirs and Check all Folders an Path if they exist"

try {
    #Create Backup Dir
    ###### FIXED #####
    if ($UseStaging -and $Zip) {
        #Logging "INFO" "Use Temp Backup Dir"
        $BackupfolderPath="\Backup-" + (Get-Date -format yyyy-MM-dd) + "-" + (Get-Random -Maximum 100000)
        $BackupDestination = $StagingPath + $BackupfolderPath + "\"
    }
    else {
        #Logging "INFO" "Use orig Backup Dir"
        $BackupDestination = $Destination + $BackupfolderPath + "\"
    }
    #$BackupDestination = $Destination + "\Backup-" + (Get-Date -format yyyy-MM-dd) + "-" + (Get-Random -Maximum 100000) + "\"
    #######################
    
    
    New-Item -Path $BackupDestination -ItemType Directory | Out-Null
    Start-sleep -Seconds 5
    Write-au2matorLog -Type Info -Text "Create Backupdir $BackupDestination"

    try {
        #Ceck all Directories
        Write-au2matorLog -Type Info -Text "Check if BackupDirs exist"
        $Backupdirs

        foreach ($Dir in $Backupdirs) {
            if ((Test-Path $Dir)) {
                
                Write-au2matorLog -Type INFO -Text "$Dir is fine"
                $FinalBackupdirs += $Dir
            }
            else {
                Write-au2matorLog -Type WARNING -Text "$Dir does not exist and was removed from Backup"
            }
        }
        try {
            if ($UseStaging) {
                if ((Test-Path $StagingPath)) {
                
                    Write-au2matorLog -Type INFO -Text "$StagingPath is fine"
                }
                else {
                    Write-au2matorLog -Type ERROR -Text "$StagingPath does not exist"
                    Write-au2matorLog -Type ERROR -Text $Error
                    $PreCheck = $false
                }
            }
        }
        catch {
            Write-au2matorLog -Type ERROR -Text "Failed to Check Staging Dir $StagingPath"
            Write-au2matorLog -Type ERROR -Text $Error
            $PreCheck = $false
        }
    }
    catch {
        Write-au2matorLog -Type ERROR -Text "Failed to Check Backupdir $BackupDestination"
        Write-au2matorLog -Type ERROR -Text $Error
        $PreCheck = $false
        
    }
}
catch {
    Write-au2matorLog -Type ERROR -Text "Failed to Create Backupdir $BackupDestination"
    Write-au2matorLog -Type ERROR -Text $Error
    $PreCheck = $false
}


## BACKUP
if ($PreCheck) {
    Write-au2matorLog -Type INFO -Text "PreCheck was good, so start with Backup"

    try {
        Write-au2matorLog -Type INFO -Text "Calculate Size and check Files"
        $BackupDirFiles = @{ } #Hash of BackupDir & Files
        $Files = @()
        $SumMB = 0
        $SumItems = 0
        $SumCount = 0
        $colItems = 0
        $ExcludeString = ""
foreach ($Entry in $ExcludeDirs.ToUpper()) {
    #Exclude the directory itself
    $Temp = "^" + $Entry.Replace("\", "\\") + "$"
    $ExcludeString += $Temp + "|"

    #Exclude the directory's children
    $Temp = "^" + $Entry.Replace("\", "\\") + "\\.*"
    $ExcludeString += $Temp + "|"
}
$ExcludeString = $ExcludeString.Substring(0, $ExcludeString.Length - 1)
[RegEx]$exclude = $ExcludeString
        
        foreach ($Backup in $FinalBackupdirs) {
###### FIXED ##### Commented out
            # $Files = Get-ChildItem -LiteralPath $Backup -recurse -Attributes D+!ReparsePoint, D+H+!ReparsePoint -ErrorVariable +errItems -ErrorAction SilentlyContinue | 
            # ForEach-Object -Process { Add-Member -InputObject $_ -NotePropertyName "ParentFullName" -NotePropertyValue ($_.FullName.Substring(0, $_.FullName.LastIndexOf("\" + $_.Name))) -PassThru -ErrorAction SilentlyContinue } |
            # Where-Object { $_.FullName -notmatch $exclude -and $_.ParentFullName -notmatch $exclude } |
            # Get-ChildItem -Attributes !D -ErrorVariable +errItems -ErrorAction SilentlyContinue | Where-Object { $_.DirectoryName -notmatch $exclude }
            # #$BackupDirFiles.Add($Backup, $Files)

            # $Files 
#################
            $Files+= Get-ChildItem -LiteralPath $Backup  | 
            ForEach-Object -Process { Add-Member -InputObject $_ -NotePropertyName "ParentFullName" -NotePropertyValue ($_.FullName.Substring(0, $_.FullName.LastIndexOf("\" + $_.Name))) -PassThru -ErrorAction SilentlyContinue } |
            Get-ChildItem -Attributes !D -ErrorVariable +errItems -ErrorAction SilentlyContinue
            $BackupDirFiles.Add($Backup, $Files)

    
            $colItems = ($Files | Measure-Object -property length -sum) 
            $Items = 0
            
            $SumMB += $colItems.Sum.ToString()
            $SumItems += $colItems.Count
        }
    
        $TotalMB = "{0:N2}" -f ($SumMB / 1MB) + " MB of Files"
        Write-au2matorLog -Type INFO -Text "There are $SumItems Files with  $TotalMB to copy"
    
        #Log any errors from above from building the list of files to backup.
        [System.Management.Automation.ErrorRecord]$errItem = $null
        foreach ($errItem in $errItems) {
            Write-au2matorLog -Type WARNING -Text ("Skipping `"" + $errItem.TargetObject + "`" Error: " + $errItem.CategoryInfo)
        }
        Remove-Variable errItem
        Remove-Variable errItems

        try {
            Write-au2matorLog -Type INFO -Text "Run Backup"


            foreach ($Backup in $FinalBackupdirs) {
                $Index = $Backup.LastIndexOf("\")
                $SplitBackup = $Backup.substring(0, $Index)
        
                $Files = $BackupDirFiles[$Backup]
           
                foreach ($File in $Files) {
                    $restpath = $file.fullname.replace($SplitBackup, "")
                    try {
                        # Use New-Item to create the destination directory if it doesn't yet exist. Then copy the file.
                        # remove extra/last slash
                        ###### FIXED #####

                        if(($File.DirectoryName.ToUpper()) -notmatch $exclude ){
                            
                        $mypath= (Split-Path -Path $($BackupDestination.Substring(0,$BackupDestination.Length-1) + $restpath) -Parent)
                        New-Item -Path $mypath -ItemType "directory" -Force -ErrorAction SilentlyContinue | Out-Null
                        Copy-Item -LiteralPath $file.fullname -Destination $($BackupDestination.Substring(0,$BackupDestination.Length-1) + $restpath) -Force -ErrorAction SilentlyContinue | Out-Null
                        Write-au2matorLog -Type Info -Text $("'" + $File.FullName + "' was copied")
                        
                        }
                        ##################
                    }
                    catch {
                        $ErrorCount++
                        Write-au2matorLog -Type Error -Text $("'" + $File.FullName + "' returned an error and was not copied")
                    }
                    $Items += (Get-item -LiteralPath $file.fullname).Length
                    $Index = [array]::IndexOf($BackupDirs, $Backup) + 1
                    $Text = "Copy data Location {0} of {1}" -f $Index , $BackupDirs.Count
                    if ($File.Attributes -ne "Directory") { $count++ }
                }
            }
            $SumCount += $Count
            $SumTotalMB = "{0:N2}" -f ($Items / 1MB) + " MB of Files"
            Write-au2matorLog -Type Info -Text "----------------------"
            Write-au2matorLog -Type Info -Text "Copied $SumCount files with $SumTotalMB"
            if ($ErrorCount ) { Write-au2matorLog -Type Info -Text "$ErrorCount Files could not be copied" }

            $BackUpCheck = $true
        }
        catch {
            
            Write-au2matorLog -Type ERROR -Text "Failed to Backup"
            Write-au2matorLog -Type ERROR -Text $Error
            $BackUpCheck = $false
        }
    }
    catch {
        Write-au2matorLog -Type ERROR -Text "Failed to Measure Backupdir"
        Write-au2matorLog -Type ERROR -Text $Error
        $BackUpCheck = $false
    }
}
else {
    Write-au2matorLog -Type ERROR -Text "PreCheck failed so do not run Backup"
    $BackUpCheck = $false
}


## ZIP
if ($BackUpCheck) {
    Write-au2matorLog -Type INFO -Text "BAckUpCheck is fine, so lets se if we need to ZIP"
    
    if ($ZIP) {
        Write-au2matorLog -Type INFO -Text "ZIP is on, so lets go"

        if ($Use7ZIP) {
            Write-au2matorLog -Type INFO -Text "We should use 7Zip for this"
        
            try {
                Write-au2matorLog -Type INFO -Text "Check for the 7ZIP Module"
                if (Get-Module -Name 7Zip4Powershell) {
                    Write-au2matorLog -Type INFO -Text "7ZIP Module is installed"
                }
                else {
                
                    Write-au2matorLog -Type INFO -Text "7ZIP Module is not installed, try to install"
                    Install-Module -Name 7Zip4Powershell -Force
                    Import-Module 7Zip4Powershell
                }
                    # Already defined previously
                $Zip = $BackupDestination #$StagingPath + ("\" + $BackupDestination.Replace($Destination, '').Replace('\', '') + ".zip")
                
                Write-au2matorLog -Type Info -Text "Compress File"
                Compress-7Zip -ArchiveFileName $Zip -Path $BackupDestination
                            
                Write-au2matorLog -Type Info -Text "Move Zip to Destination"
                Move-Item -Path $Zip -Destination $Destination

                $ZIPCheck = $true
            }
            catch {
                Write-au2matorLog -Type ERROR -Text "Error on 7ZIP compression"
                Write-au2matorLog -Type ERROR -Text $Error
                $ZIPCheck = $false
            }
        }
        else {
            ###### FIXED #####
            Write-au2matorLog -Type Info -Text "Use Powershell Compress-Archive"
            Compress-Archive -Path ($BackupDestination + "\*") -DestinationPath ($Destination + ($BackupfolderPath + ".zip")) -CompressionLevel Optimal -Force
           # remove from staging
           Remove-Item -Path $BackupDestination -Force -Confirm:$false  -ErrorAction SilentlyContinue -Recurse | Out-Null
            ###################           
        }
    }
    else {
        Write-au2matorLog -Type INFO -Text "No Zip, so go ahead"
    }


}
else {
    Write-au2matorLog -Type ERROR -Text "BAckUpCheck failed so do not try to ZIP"
}





##CLEANUP BACKUP
if ($Zip -and $RemoveBackupDestination -and $ZIPCheck)
{
    try {
        Write-au2matorLog -Type INFO -Text "Lets remove Backup Dir after ZIP"
        #Remove-Item -Path $BackupDir -Force -Recurse 
        get-childitem -Path $BackupDestination -recurse -Force | remove-item -Confirm:$false -ErrorAction SilentlyContinue -Recurse 
        get-item -Path $BackupDestination | remove-item -Confirm:$false  -ErrorAction SilentlyContinue -Recurse | Out-Null

    }
    catch {
        Write-au2matorLog -Type ERROR -Text "Error to Remove Backup Dir: $BackupDestination"
        Write-au2matorLog -Type ERROR -Text $Error
        
    }
}


##CLEANUP VERSION
Write-au2matorLog -Type Info -Text "Cleanup Backup Dir"

$Count = (Get-ChildItem $Destination | Where-Object { $_.Attributes -eq "Directory" }).count
if ($count -gt $Versions) {
    Write-au2matorLog -Type Info -Text "Found $count Backups"
    $Folder = Get-ChildItem $Destination | Where-Object { $_.Attributes -eq "Directory" } | Sort-Object -Property CreationTime -Descending:$false | Select-Object -First 1

    Write-au2matorLog -Type Info -Text "Remove Dir: $Folder"
    
    $Folder.FullName | Remove-Item -Recurse -Force 
}


$CountZip = (Get-ChildItem $Destination | Where-Object { $_.Attributes -eq "Archive" -and $_.Extension -eq ".zip" }).count
Write-au2matorLog -Type Info -Text "Check if there are more than $Versions Zip in the Backupdir"

if ($CountZip -gt $Versions) {

    $Zip = Get-ChildItem $Destination | Where-Object { $_.Attributes -eq "Archive" -and $_.Extension -eq ".zip" } | Sort-Object -Property CreationTime -Descending:$false | Select-Object -First 1

    Write-au2matorLog -Type Info -Text "Remove Zip: $Zip"
    
    $Zip.FullName | Remove-Item -Recurse -Force 

}