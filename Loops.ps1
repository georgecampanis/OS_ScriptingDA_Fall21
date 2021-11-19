# More on Pipelines

Dir | more

Dir | Sort-Object Length -Descending | Select-Object Name, Length | ConvertTo-Html | Out-File "C:\temp\reportDA.htm"
.\reportDA.htm

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

Dir c:\temp -recurse | more
Dir c:\temp -recurse | Out-Host -paging



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

Dir | Format-Table Name, Length, Extension, CreationTime


#Transforming objects produced by the pipeline is carried out by formatting cmdlets.
Get-Command -verb format

#display particular properties
Dir | Format-Table Name, Length, CreationTimeUtc, Directory


#Wildcard characters are allowed so the next command outputs all running processes that begin with "l". All properties starting with "pe" and ending in "64" are output
Get-Process i* | Format-Table name,pe*64

Dir | Format-Table Name, { [int]($_.Length/1KB) }

# elapsed from the LastWriteTime property up to the current date 
Dir | Format-Table Name, Length, {(New-TimeSpan $_.LastWriteTime (Get-Date)).Days} -autosize


$column1 = @{Expression={ [int]($_.Length/1KB) }; Label="KB";  width=150 }
$column2 = @{Expression="LastWriteTime"; Label="Written"; width=150 ; alignment="right" }
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


#grouping
Get-Service | Group-Object Status

$result = Get-Service | Group-Object Status
$result[1].Group

$result.GetType().Name

Dir  | Group-Object Extension | Sort-Object Count -descending


Dir | Group-Object {$_.Length -gt 100KB}

$result2 = Dir | Group-Object {$_.Length -gt 350KB}
$result2[1].Group


Dir | Group-Object {$_.name.SubString(0,1).toUpper()}
Dir | Group-Object {$_.name.SubString(0,$_.name.IndexOf(".")).toUpper()}


$myString="Mahesh Chand, Henry He, Chris Love, Raj Beniwal, Praveen Kumar"
[int] $str1= $myString.IndexOf("Chand")
[int] $str2= $myString.IndexOf("Raj")

$res=$myString.Substring($str1, $str2-$str1)
$res

Dir | Group-Object {$_.name.SubString(0,1)}

# =>foreach
Dir | Group-Object {$_.name.SubString(0,1).toUpper()} | 
ForEach-Object { ($_.Name)*7; "======="; $_.Group} 


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
        "This president: $($p.FName) $($p.LName) was awesome!"
        "This president: {0} {1} {2}" -f $p.FName, $p.LName, "was awesome!"
        "This president: {0} {1} was awesome!" -f $p.FName, $p.LName
    }else {
        "This president: {0} {1} {2}" -f $p.FName, $p.LName, "was good, but not awesome!"
        }
    
}



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

notepad

    Get-Process notepad | ForEach-Object { $_.Kill() }# envoke methods



Notepad
$processes = @(Get-Process notepad)
$process=$processes[2]
$process.StartTime

New-TimeSpan $processes[0].StartTime (Get-Date)

New-TimeSpan $process.StartTime (Get-Date)


notepad

Get-Process notepad | ForEach-Object {$_.Kill();}




##------------------------------

Get-Process notepad | ForEach-Object {
    $time = (New-TimeSpan $_.StartTime (Get-Date)).TotalSeconds;
    if ($time -lt (1000-15)) {
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


####
$day=9
switch ( $day ) {
    0 { 'Sunday' } 
    1 { 'Monday' } 
    2 { 'Tuesday' } 
    3 { 'Wednesday' } 
    4 { 'Thursday' } 
    5 { 'Friday' } 
    6 { 'Saturday' } 
    default {"This is not a day of the week"}
}


# filters results out before you can use them so use switch statement to get all possibilities
 Switch (Get-Process notepad) {
    {
    $time = (New-TimeSpan $_.StartTime (Get-Date)).TotalSeconds;
    $time -le 1000
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


$array[0]*$array[2]

$array[0].GetType().Name
$array[2].GetType().Name

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


#############################################################
#    TRY CATCH AND ERROR HANDLING
############################################################
<# BASICS 

Exception
An Exception is like an event that is created when normal error handling can't deal with the issue. 
Trying to divide a number by zero or running out of memory are examples of something that creates an exception. 

Throw and Catch
When an exception happens, we say that an exception is thrown. To handle a thrown exception, you need to catch it. 
If an exception is thrown and it isn't caught by something, the script stops executing.

Terminating and non-terminating errors
An exception is generally a terminating error. A thrown exception is either be caught or it terminates the current execution. 
By default, a non-terminating error is generated by Write-Error and it adds an error to the output stream without throwing an exception.
NB If you specify -ErrorAction Stop, Write-Error generates a terminating error that can be handled by a catch.

Ref List of Exceptions: https://powershellexplained.com/2017-04-07-all-dotnet-exception-list/

#>


# TRY CATCH 
# ref: https://jeffbrown.tech/using-exception-messages-with-try-catch-in-powershell/
try {
    New-Item -Path C:\doesnotexist -Name myfile.txt  -ItemType File  -ErrorAction Stop
}
catch {
    Write-Warning -Message "Oops, ran into an issue"
}

# grab ps error
try {
    New-Item -Path C:\doesnotexist  -Name myfile.txt -ItemType File -ErrorAction Stop
}
catch {
    Write-Warning $Error[0] # $error array of errors [0] is the last error
}

try {
    New-Item -Path C:\doesnotexist `
        -Name myfile.txt `
        -ItemType File `
        -ErrorAction Stop
}
catch {
    $message = $_
    Write-Warning "Something happened! $message"
}


try {
    New-Item -Path C:\doesnotexist   -Name myfile.txt  -ItemType File  -ErrorAction Stop
}
catch [System.NotSupportedException] { #
    Write-Warning "Bad char found in path!"
}
catch [System.IO.DirectoryNotFoundException] { #System.IO.DirectoryNotFoundException
    Write-Warning "File could not be found!"
}
catch{
    Write-Warning "An unexpected error occured!"
}
finally{ 
    Write-Host "cleaning up loose ends…"
}


$error[0].Exception.GetType().Fullname
#System.IO.DirectoryNotFoundException





