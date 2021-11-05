# More on Pipelines

Dir | more

Dir | Sort-Object Length -Descending | Select-Object Name, Length | ConvertTo-Html | Out-File "C:\temp\report2.html"
.\report2.html

# pipeline cmdlets and functions


# Attention: danger!
Dir C:\ -recurse | Sort-Object

<#

In this example Dir returns all files and directors of C:\. These results are
passed by the pipeline to Sort-Object, and because Sort-Objectcan only sort
the results when all of them are available, it collects the results as they come
in. Those results then create a "data jam" in the pipeline. 

Problem 1:  You won't see any activity as long as data is being collected.
The more data that has to be acquired, the longer the wait time will be. 

Problem 2:  Because enormous amounts of data have to be stored
temporarily before Sort-Object can process them, the memory space
requirement is very high. I
#>

Dir c:\ -recurse | more
Dir c:\ -recurse | Out-Host -paging



<#end
The cmdlet Out-Host means you don't have to wait. Its parameter -paging also supports page-bypage outputs. Because this cmdlet supports streaming, you won't have to sit in front of the console
twiddling your thumbs:

#>

#Converting Objects into Text
Dir
Dir | Out-Default #return visible results, not objects

#Out-Default transforms the pipeline result into visible text.
Dir | Format-Table | Out-Host


Dir | Format-Table * # see all the object properties
Dir | Format-Table * -wrap

#PowerShell uses Format-List instead of Format-Table whenever there are more than five propertiesto display
Dir | Format-List *


#Transforming objects produced by the pipeline is carried out by formatting cmdlets.
Get-Command -verb format

#display particular properties
Dir | Format-Table Name, Length, CreationTimeUtc, Directory


#Wildcard characters are allowed so the next command outputs all running processes that begin with "l". All properties starting with "pe" and ending in "64" are output
Get-Process i* | Format-Table name,pe*64

Dir | Format-Table Name, { [int]($_.Length/1KB) }

# elapsed from the LastWriteTime property up to the current date 
Dir | Format-Table Name, Length, {(New-TimeSpan $_.LastWriteTime (Get-Date)).Days} -autosize


$column1 = @{Expression={ [int]($_.Length/1KB) }; Label="KB";  }
$column2 = @{Expression="LastWriteTime"; Label="Written"; width=130 ; alignment="right" }
Dir | Format-Table  Name, $column1,$column2 



<#
If you output the result of Get-Process without further specifications, PowerShell will routinely
convert the following Process properties objects into text
#>

# views and propertyset
Get-Process | Format-Table PSConfiguration
# get property set options
Get-Process | Get-Member -MemberType PropertySet

# Views work in a similar way as they set not just the properties that are to be converted into text, but
# they can also specify column names or widths and even group information.

# All running processes grouped after start time:
Get-Process | Format-Table -view StartTime
# All running processes grouped according to priority:
Get-Process | Format-Table -view Priority

# Views are highly specific and always apply to particular object types and particular formatting cmdlets.
Get-Process | Format-List -view Priority

<#
sorting and grouping
#>
Dir | Sort-Object -property Length -descending # -property allows you to use any object property as a sorting criterion

Dir | Sort-Object Length, Name





#The hash table makes it possible to append additional information to a property, so you can separately specify for each property the sorting sequence you prefer
Dir | Sort-Object @{expression="Length";Descending=$true}, @{expression="Name";Ascending=$true}

$hash=@{"Tobias"=90;"Martina"=90;"Cofi"=80;"Zumsel"=100}
$hash | Sort-Object Value -descending

$hash.GetEnumerator() | Sort-Object Value -descending
$hash.GetEnumerator() | Sort-Object Name

$presidents = @{FName="Joe"; LName="Biden"},
@{FName="Bill"; LName="Clinton"},
@{FName="Barrack"; LName="Obama"}

Foreach($p in $presidents)
{
    if($p.LName -eq "Obama")
    {
        "This president: {0} {1} {2}" -f $p.FName, $p.LName, "was awesome!"
    }else {
        "This president: {0} {1} {2}" -f $p.FName, $p.LName, "was good, but not awesome!"
        }
    
}



#grouping
Get-Service | Group-Object Status

$result = Get-Service | Group-Object Status
$result[1].Group


Dir | Group-Object Extension | Sort-Object Count -descending


Dir | Group-Object {$_.Length -gt 100KB}

$result2 = Dir | Group-Object {$_.Length -gt 350KB}
$result2[1].Group


Dir | Group-Object {$_.name.SubString(0,1).toUpper()}
Dir | Group-Object {$_.name.SubString(0,1)}

# =>foreach
Dir | Group-Object {$_.name.SubString(0,1).toUpper()} | 
ForEach-Object { ($_.Name)*7; "======="; $_.Group} 


 #########################
 ## ForEach-Object
 ###############################
 Get-WmiObject Win32_Service | Format-Table Name, StartMode, PathName

### -f => Format operator (https://social.technet.microsoft.com/wiki/contents/articles/7855.powershell-using-the-f-format-operator.aspx)
 Get-WmiObject Win32_Service |
 ForEach-Object { "{3} {0} ({1}): Path: {2}" -f $_.Name, $_.StartMode, $_.PathName, "This is var 1 - " }

#with conditions
 Get-WmiObject Win32_Service |  ForEach-Object {
 if ($_.Started) {
 "{0}({1}) " -f $_.Caption, $_.Started
    }
 }


 Get-WmiObject Win32_Service | Where-Object { $_.Started } | ForEach-Object {
    "{0}({1})"-f $_.Caption,  $_.Started  }#, $_.Name, $_.Description

 # shorthand ? = where % = foreach

 Get-WmiObject Win32_Service | ? { $_.Started } | % {
    "{0}({1})"-f $_.Caption,  $_.Started  }#, $_.Name, $_.Description
#################################
###==> DBA Class Start Here
#################################
notepad

    Get-Process notepad | ForEach-Object { $_.Kill() }# envoke methods



Notepad
$processes = @(Get-Process notepad)
$process=$processes[0]
$process.StartTime

New-TimeSpan $processes[0].StartTime (Get-Date)

New-TimeSpan $process.StartTime (Get-Date)


notepad

Get-Process notepad | ForEach-Object {$_.Kill();}




##------------------------------

Get-Process notepad | ForEach-Object {
    $time = (New-TimeSpan $_.StartTime (Get-Date)).TotalSeconds;
    if ($time -lt 1000) {
    "Stop process $($_.id) after $time seconds...";
    $_.Kill()
    }
    else {
    "Process $($_.id) has been running for " +
    "$time seconds and have not be stopped."
    } 
}

notepad.exe


Get-Process notepad| Format-Table Id, ProcessName, StartTime


###### Another way
 Get-Process notepad |
 Where-Object {
 $time = (New-TimeSpan $_.StartTime (Get-Date)).TotalSeconds;
 ($time -lt 1180)
 } |
 ForEach-Object {
 "Stop process $($_.id) after $time seconds...";
 $_.Kill()
 }



# filters results out before you can use them so use switch statement to get all possibilities
 Switch (Get-Process notepad) {
    {
    $time = (New-TimeSpan $_.StartTime (Get-Date)).TotalSeconds;
    $time -le 1
    }
    {
    "Stop process $($_.id) after $time seconds...";
    $_.Kill()
    }
    default {"Process $($_.id) has been running for some time and will not be stopped."}
   }
   

# ForEach-Object lists each element in a pipeline:
Dir C:\ | ForEach-Object { $_.name }
# Foreach loop lists each element in a colection:
Foreach ($element in Dir C:\) { $element.name }

# Foreach loop lists each element in a collection:
Foreach ($element in Dir C:\ -recurse) { $element.name } # bad option
# ForEach-Object lists each element in a pipeline:
Dir C:\ -recurse | ForEach-Object { $_.name } # good option 

# Create your own array:
$array = 3,6,"Hello",12

# Read out this array element by element:
foreach ($e in $array) {
    "Current element: $e"
}


# Process all files and subdirectories in a directory separately:
Foreach ($entry in dir C:\Windows\Logs) {
    # Either embed the data as subexpressions in a text:
    "File $($entry.name) is $($entry.length) bytes"
    # Or use wildcards and the -f formatting operator:
    "File {0} is {1} bytes" -f $entry.name, $entry.length
   }
   

   # Use WMI to query all services of the system:
$services = Get-WmiObject Win32_Service
# Output the Name and Caption properties for every service:
Foreach ($s in $services) { $s.Name +
 " = " + $s.Caption }


 function open-editor ([string]$path="$home\*.htm") {
    $list = Resolve-Path -Path $path
    Foreach ($file in $list) {
    "Open File $file..."
    notepad $file
    }
   }
   
 
   open-editor
   open-editor $env:windir\*.log




   # Process all files and subdirectories in a directory one by one:
Foreach ($entry in dir c:\) {
    # Is it a FileInfo object?
    if ($entry -is [System.IO.FileInfo]) {
    # If yes, output name and size:
    "File {0} is {1} bytes large" -f $entry.name, $entry.length
    }
    # Or is it perhaps a DirectoryInfo object?
    elseif ($entry -is [System.IO.DirectoryInfo]) {
    # If yes, output name and creation time:
    "Subdirectory {0} was created on {1:}" -f $entry.name,
    $entry.CreationTime
    }
   }
   

   ######
   # Do While
   ####endregion
   Do {
    $input = Read-Host "Your homepage"
   } While (!($input -like "www.*.*"))
  
   # Open a file for reading:
$file = [system.io.file]::OpenText("C:\autoexec.bat")
# Continue loop until the end of the file has been reached:
While (!($file.EndOfStream)) {
 # Read and output current line from the file:
 $file.ReadLine()
}



# Close file again:
$file.close


######
Do {
    $input = Read-Host "Your Homepage"
    if ($input -like "www.*.*") {
    # Input correct, no further query:
    $furtherquery = $false
    } else {
    # Input incorrect, give explanation and query again:
    Write-Host -Fore "Red" "Please give a valid web address."
    $furtherquery = $true
    }
} While ($furtherquery) 

## Careful here Endless loop
While ($true) {
    $input = Read-Host "Your homepage"
    if ($input -like "www.*.*") {
    # Input correct, no further query:
    break
    } else {
    # Input incorrect, give explanation and ask again:
    Write-Host -Fore "Red" "Please give a valid web address."
    }
}


# Create random number generator
$random = New-Object system.random

# Output seven random numbers from 1 to 49
for ($i=0; $i -lt 7; $i++) {
 $random.next(1,49)
} 


foreach ($e in $array) {
    "Current element: $e"
}



   
# First expression: simple While loop:
$i = 0
While ($i -lt 5) {
 $i++
 $i
} 
# Second expression: the For loop behaves like the While loop:
$i = 0
For (;$i -lt 5;) {
 $i++
 $i
} 


#exit loop
While ($true)
{
 $password = Read-Host "Enter password"
 If ($password -eq "secret") {break}
}

While ($true)
{
 $password = Read-Host "Enter password"
 If ($password -eq "secret") {continue}
}


For ($i=1; $i -lt 4; $i++)
{
 $password = Read-Host "Enter password ($i. try)"
 If ($password -eq "secret") {break}
 If ($i -ge 3) { Throw "The entered password was incorrect." }
}

#skipping loop
Foreach ($entry in Dir $env:windir)
{
 # If the current element matches the desired type,
 # continue immediately with the next element:
 If (!($entry -is [System.IO.FileInfo])) { Continue }
 "File {0} is {1} bytes large." -f $entry.name, $entry.length
}
# OR 
Foreach ($entry in Dir $env:windir)
{
 If ($entry -is [System.IO.FileInfo]) {
 "File {0} is {1} bytes large." -f $entry.name, $entry.length
 }
}


#nested loops
Foreach ($wmiclass in "Win32_Service","Win32_UserAccount","Win32_Process")
{
 Foreach ($instance in Get-WmiObject $wmiclass) {
 If (!(($instance.name.toLower()).StartsWith("a"))) {continue}
 "{0}: {1}" -f $instance.__CLASS, $instance.name
}
}




#Back to Pipeline chapter page 127
Dir | Format-Table -property Extension, Name -groupBy Extension

Dir | Sort-Object Extension, Name -Descending | Format-Table -groupBy Extension


#Filtering Objects Out of the Pipeline
$result = Get-Service
$result[0] | Format-List *

function MyFunc([string] $ServiceName)
{



}

Get-Service | Where-Object { $_.ServiceName -eq "gupdate"}

Get-Service | Where-Object { $_.Status -eq "Running" }
$services = Get-WmiObject Win32_Service
$services[0] | Format-List *


Get-WmiObject Win32_Service |
 ? {($_.Started -eq $false) -and ($_.StartMode -eq "Auto")} |
 Format-Table 

 Get-WmiObject -query "select * from win32_Service where `
 Started=false and StartMode='Auto'" | Format-Table

 #Selecting Object Properties
 Get-WmiObject Win32_UserAccount -filter `
 "LocalAccount=True AND Name='guest'"

 Get-WmiObject Win32_UserAccount -filter `
 "LocalAccount=True AND Name='guest'" |
 Select-Object Name, Disabled, Description

 <# The significant difference: Format-Table converts properties specified to the object into text. In
contrast, Select-Object creates a completely new object containing just these specified properties: #>

Get-WmiObject Win32_UserAccount -filter `
 "LocalAccount=True AND Name='guest'" |
 Select-Object Name, Disabled, Description |
 Format-Table *

<#  You should make sparing use of Select-Object because it takes a
 disproportionate effort to create a new object. Instead, use
 formatting cmdlets to specify which object properties are to be
 displayed. Select-Object is particularly useful when you don't want
 to convert a pipeline result into text, but instead want to output a
 comma-separated list using Export-Csv or HTML code using ConvertTo-Html. #>

 Dir | Select-Object * -exclude PS*


 #Limiting Number of Objects
 # List the five largest files in a directory:
Dir | Sort-Object Length -descending |Select-Object -first 5

# List the five longest-running processes:
Get-Process | Sort-Object StartTime |Select-Object -last 5 | Format-Table ProcessName, StartTime

# Alias shortcuts make the line shorter but also harder to read:
gps | sort StartTime -ea SilentlyContinue |select -last 5 | ft ProcessName, StartTime


#Processing All Pipeline Results Simultaneously

Get-Service | ForEach-Object {
    "The service {0} is called '{1}': {2}" -f `
    $_.Name, $_.DisplayName, $_.Status }

    #Removing Dups - must be SORTED First
    1,2,3,1,2,3,1,2,3 | Get-Unique

    1,2,3,1,2,3,1,2,3 | Sort-Object | Get-Unique

#Statistical Calculations
Dir | Measure-Object Length
Dir | Measure-Object Length -average -maximum -minimum -sum

<# #Measure-Object can also search through other text files and ascertain the frequency of characters,
words, and lines in them #>
Get-Content C:\temp\test.txt | Measure-Object -character -line -word

# Comparing Before-and-After Conditions
$s1 = "orge"
$s2 = "George"
Compare-Object $s1 $s2


$before = Get-Process
$after = Get-Process
Compare-Object $before $after



#Detecting Changes to Objects

# Save current state:
$before = Get-Service
# Pick out a service and stop this service:
# (Note: this usually requires administrator rights.
# Stop services only if you are sure that the service
# is absolutely not required.
$service = Get-Service wuauserv
$service.Stop()
# Record after state:
$after = Get-Service
# A simple comparison will not find differences because
# the service existed before and after:
Compare-Object $before $after
# A comparison of the Status property reports the halted
# service but not its name:
Compare-Object $before $after -Property Status

#Saving Snapshots for Later Use
Get-Process | Export-Clixml before.xml
$before = Import-Clixml before.xml
$after = Get-Process
Compare-Object $before $after

#Exporting Pipeline Results
Get-Command -verb out

Dir | Out-File output.txt .\output.txt
Dir | Out-Printer

# This command not only creates a new directory but also returns
# the new directory:
md testdirectory
rm testdirectory

# Here the command output is sent to "nothing"
md testdirectory | Out-Null
rm testdirectory
# That matches the following redirection:
md testdirectory > $null
rm testdirectory

#Changing Pipeline Formatting
