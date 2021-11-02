
###############################################
# Calculating with Number Systems and Units   #
###############################################

(12+5) * 3 / 4.5 
4GB / 720MB 
1mb

#hexadecimal values: simply prefix the number with "0x"
12 + 0xAF
0xAFFE # hex
<#
quick summary:
• Operators: Arithmetic problems can be solved with the help of operators. Operators evaluate
the two values to the left and the right. For basic operations, a total of five operators are
available, which are also called "arithmetic operators" => +, -, *, /, % modulo (7%4=3 and 5%4.5 = 0.5 which is the rest of the division)
• Brackets: Brackets group statements and ensure that expressions in parentheses are
evaluated first.
• Decimal point: Fractions use a point as decimal separator (never a comma).
• Comma: Commas create arrays and so are irrelevant for normal arithmetic operations.
• Special conversions: Hexadecimal numbers are designated by the prefix "0x", which
ensures that they are automatically converted into decimal values. If you add one of the KB,
MB, or GB units to a number, the number will be multiplied by the unit. 
#>


###############################################
# Executing External Commands
###############################################

ipconfig # can run  Fns
Tracert nscc.ca
defrag C: # security issues
<#  Run vcode in admin mode shift+cntrl #>


"C:\Windows\System32\notepad.exe"
&"C:\Windows\System32\notepad.exe" # The "&" changes string into commands:

notepad
wordpad #doesnt work
&"c:\program files\windows nt\accessories\wordpad.exe"

<#
The "&" changes string into commands: PowerShell doesn't treat text in quotes as a
command. Prefix string with "&" to actually execute it. The "&" symbol allows you to execute
any string just as if you had entered the text directly on the command line. 

PowerShell distinguishes between trustworthy folders and all other folders. You won't need to
provide the path name or append the file extension to the command name if the program is located
in a trustworthy folder. Commands like ping or ipconfig work as-is because they are in located a
trustworthy folder, while the program in our last example, WordPad, is not.

# "env" search bar
$env:Path # trustworthy paths
$env:path += ";C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Accessories"

#>

###############################################
# Using parameters
###############################################
Get-ChildItem c:\windows # parameters

Get-Help Get-ChildItem -full
Get-Help ls -full


#### NOTE: -path <string[]>
<# 
-include <string[]>

Retrieves only the specified items. The value of this parameter qualifies the Path parameter. Enter a
path element or pattern, such as "*.txt". Wildcards are permitted.
example:  "*.txt"

NOTE: The Include parameter is effective only when the command includes the Recurse parameter or the
path leads to the contents of a directory, such as C:\Windows\*, where the wildcard character
specifies the contents of the C:\Windows directory.


#>

Get-Help Get-ChildItem -full >C:\temp\help.txt
notepad C:\temp\help.txt

Get-ChildItem -path c:\windows\System32 -include *.log  -recurse -name 
#('*.txt','*.log') -recurse -name


-recurse


Get-ChildItem c:\windows\System32 *.txt  -recurse -name # -name will only retrieve the names of items found

Get-ChildItem -path c:\windows\System32 -include *.txt  -recurse -name
Get-ChildItem -path c:\windows\System32 -include ('*.txt','*.log')  -recurse -name

gci c:\windows\System32 *.txt  -recurse -name


Get-ChildItem -recurse  c:\windows\System32 *.txt  -name

Get-ChildItem -path c:\windows\System32 -filter *.txt 
Get-ChildItem c:\windows\System32 -filter *.txt 

Get-ChildItem  -filter *.txt -path c:\windows\System32
Get-ChildItem -name c:\windows\System32 *.txt  -recurse 

Get-ChildItem -path c:\windows\System32 -filter *.txt -recurse -name
Get-ChildItem -pa c:\windows\System32 -fi *.txt -r -n

Get-ChildItem -recurse -name  c:\windows\System32 *.txt

help Get-Process -full >C:\temp\getprocess_help.txt
notepad C:\temp\getprocess_help.txt

Get-Process ('dwm','Idle','YourPhone')
gps ("dwm","Idle","YourPhone")


#################################################################
$alias:Dir
$alias:ls
$alias:gci

<#
$alias:Dir lists the element Dir of the drive alias:. That may seem somewhat surprising because
there is no drive called alias: in the classic console. In contrast, PowerShell works with many
different virtual drives, and alias: is only one of them. If you want to know more, the cmdlet GetPSDrive lists them all. You can also list alias: like any other drive with Dir. The result would be a list
of aliases in their entirety:

#>

Get-alias -name Dir

Get-Alias | Where-Object {$_.Definition -eq "Get-ChildItem"}
Get-Alias | Where-Object {$_.Definition -eq "Get-Process"}

Get-Alias | ? {$_.Definition -eq "Get-Process"}
Get-Alias | where {$_.Definition -eq "Get-Process"}

Dir alias: | Out-String -Stream | Select-String "Get-ChildItem"

Dir alias: | Group-Object definition
##############################################################
Set-Alias edit notepad.exe -Option "Allscope" -Scope "Global" # create your own alias
edit
$alias:edit 


Export-Alias "C:\temp\myalias"
notepad "C:\temp\myalias"

#Import-Alias "C:\Users\w0038182\OneDrive - Nova Scotia Community College\Classes\Fall2020\INET - Server Scripting\PowerSellScripts\myalias"
#Import-Alias "C:\Users\w0038182\OneDrive - Nova Scotia Community College\Classes\Fall2020\INET - Server Scripting\PowerSellScripts\myalias" -force

Del alias:edit
edit

#########################################
# Variables
#########################################

# Create variables and assign to values
[double]$amount = 120.1
$VAT = 0.19
# Calculate:
$result = [Math]::Round($amount * $VAT,2)
# Output result
$result

# Replace variables in text with values:
$text = "Net amount $amount matches gross amount $result"
$text = "Net amount $ $amount matches gross amount $ $result"
$text = "Net amount `$$amount matches gross amount `$$result"
$text


# Variable names with special characters belong in braces:
${this variable name is "unusual," but permitted} = "Hello World"
${this variable name is "unusual," but permitted}


# Temporarily store results of a cmdlet:
$listing = Get-ChildItem c:\
$listing


# Temporarily store the result of a legacy external command:
$result = ipconfig
$result


# Populate several variables with the same value in one step:
$a = $b = $c = 1
$a


$Value1 = 10
$Value2 = 20

$Value1=$Value2 
$Value2=$Value1

$Value1
$Value2 


$Temp = $Value1
$Value1 = $Value2
$Value2 = $Temp


# Exchange variable values:
$Value1 = 10; $Value2 = 20
$Value1, $Value2 = $Value2, $Value1
$Value2
$Value1

# Populate several variables with the same value in one step:
$Value1, $Value2 = 10,20
$Value1, $Value2 = $Value2, $Value1
$Value2
$Value1

Clear-Variable Value1
$Value2 = $null

Get-Variable Value2, Value1, value3

New-Variable value3 12

#Remove-Variable a
#del variable:\value3

del variable:\Value2

get-variable *
dir variable: 

####===> Start DA class Here
<#
-ClearVariable-
Clears the contents of a variable, but not the variable
itself. The subsequent value of the variable is NULL
(empty). If a data or object type is specified for the
variable, by using Clear-Variable the type of the
objected stored in the variable will be preserved.

ClearVariable a
same as:
$a = $null

-GetVariable-
Gets the variable object, not the value in which the
variable is stored.

Get-Variable a

-NewVariable-
Creates a new variable and can set special variable
options

NewVariable value 12

-RemoveVariable-
Deletes the variable, and its contents, as long as the
variable is not a constant or is created by the
system.

RemoveVariable a
same as: del variable:\a

-SetVariable-
Resets the value of variable or variable options such
as a description and creates a variable if it does not
exist.

Set-Variable a 12
same as: $a = 12


#>
New-Variable value 12
$value1=14

#finding vars
Get-ChildItem variable:value*
ls variable:value*

# Verify whether the variable $value2 exists:
$value2=1000
Test-Path variable:\value2
Test-Path C:\temp


# create a test variable:
$test = 1
# verify that the variable exists:
Dir variable:\te*
# delete variable:
del variable:\test
# variable is removed from the listing:
Dir variable:\te*
$test = 1
Remove-Variable test
<#
-ClearVariable-
Clears the contents of a variable, but not the variable
itself. The subsequent value of the variable is NULL
(empty). If a data or object type is specified for the
variable, by using Clear-Variable the type of the
objected stored in the variable will be preserved.
ClearVariable a
same as:
$a = $null
-GetVariable-
Gets the variable object, not the value in which the
variable is stored.
Get-Variable a
-NewVariable-
Creates a new variable and can set special variable
options
NewVariable value 12
-RemoveVariable-
Deletes the variable, and its contents, as long as the
variable is not a constant or is created by the
system.
RemoveVariable a
same as: del variable:\a
-SetVariable-
Resets the value of variable or variable options such
as a description and creates a variable if it does not
exist.
Set-Variable a 12
same as: $a = 12
#>




#Clear-Variable a <=>  $a = $null
#Set-Variable a 12 <=> $a = 12

###############################################
#         Write-protection   
###############################################
# Create new variable with description and write-protection:
New-Variable test2 -value 200 -description "test variable with write-protection" -option ReadOnly
$test2


# Variable contents cannot be modified:
$test = 200

del Variable:\test2
del Variable:\test2 -force



#New-Variable cannot write over existing variables:
New-Variable testConst -value 1000 -description  "test variable with copy protection" -option Constant
$testConst

del variable:\testConst -force

ls Variable:
New-Variable test3 -value 100  -option Constant
# variables with the "Constant" option may neither be
# modified nor deleted:
del Variable:\test3 -force

# Parameter -force overwrites existing variables if these do not
# use the "Constant" option:
New-Variable test -value 100 -description "test variable" -force


Get-ChildItem variable:te*


# 
# variable contains a description:
dir Variable:\te* | Format-Table  Name, Value, Description -autosize
New-Variable test4 -value 100 -description "test variable" -Option Readonly
New-Variable test5 -value 100 

Get-Variable test | Select *

##### Can we show the option type e.g. Constant, ReadOnly, AllScope...?????
dir Variable:\te* | Format-Table  Name, options, Visibility -autosize



dir Variable:\*| Format-Table Name, Value, Description -autosize

dir Variable:\te*| Format-Table Name, Description -autosize

help Variable: > C:\temp\vars.txt
# normal variables may be overwritten with -force without difficulty.
$available = 123
$available = 123456
New-Variable available -value 100 -description "test variable" -force


#all f automatic variables 
Dir variable: | Sort-Object name | Format-Table Name,  Description -autosize -wrap

# Verify user profile:
$HOME


#"current process -ID of PowerShell is $PID"
Get-Process -id $PID

$PSHOME

#Reading Particular Environment Variables
$env:windir
 get-process -ComputerName $env:COMPUTERNAME

 Get-WmiObject -class Win32_OperatingSystem

# push in current locaction to a stack :
Push-Location
# change to Windows folder
cd $env:windir
Push-Location

cd C:\temp
# pop back to initial location after executed task
Pop-Location
Pop-Location

##Searching for Environment Variables
#Windows environment 
Dir env:
$env:userprofile


$env:windir
<# Using this statement, you've just read the contents of the environment variable windir. However, in
reality, env:windir is a file path and leads to the "file" windir on the env:drive. So, if you specify a
path name behind "$", this variable will furnish the contents of the specified "file". #>


# The path must be enclosed in braces because normal files paths include special characters like ":" and "\", which PowerShell can misinterpret

# The "`" character in front of the first "$", by the way, is not a typo but a
# character as it's known as the "backtick" character. You specify it in front of
# all characters that normally have a special meaning that you want to override
# during the current operation.  PAGE 74 https://www.bonusbits.com/uploads/Mastering-PowerShell.pdf
$command = "`${$env:windir\PFRO.log}"
Invoke-Expression $command
#$command


$thisV = "{$env:windir\PFRO.log}"
$command = "`$$thisV"
Invoke-Expression $command
$command



"Result = `$(2+2)"


# Get file:
$file = dir "$env:windir\PFRO.log"
$file.Length

"The size of the file is $([Math]::Round($file.Length/1KB,3)) kilobytes."

$fileSz= [Math]::Round($file.Length/1KB,3)
"The size of the file is $fileSz kilobytes."


#$file = "${$env:windir\PFRO.log}"
# File size given by length property:

# To embed the file size in text, ad hoc variables are required:


$fl=get-item "$env:windir\PFRO.log"


$fl.Length

"The size of the file is $($fl.Length) bytes."


###############################################
#  SCOPE   (global, local, private, and script)
###############################################

#PowerShell will automatically restrict the visibility of its variables
Notepad test1.ps1 # create script , add

if("MyString" -eq "MYSTRING")
{
    "They are equal!"
}else {
    "They are NOT equal!"
}

[string] $str1= "MyString"
[string] $str2= "MYSTRING"

if($str1 -eq $str2)
{
    "They are equal!"
}else {
    "They are NOT equal!"
}

$env:windir
<#
$windows = $env:windir
"Windows Folder: $windows"
# run 
cd C:\temp
.\test1.ps1

$ComputerName = $env:COMPUTERNAME
"My ComputerName is: $ComputerName"
#>


# local scope
$ComputerName="DefaultName"
cd C:\temp
.\test1.ps1 #script scope

#"DefaultName"

$ComputerName
# All scope
cd C:\temp
. .\test1.ps1 #script scope
# ML-RefVm-361229

$ComputerName
# with allscope
New-Variable ComputerName -value "DefaultName2"  -Option AllScope -force
$ComputerName

cd C:\temp
.\test1.ps1 #script scope

$ComputerName #=> ML-RefVm-361229

#Without allscope
New-Variable ComputerName -value "DefaultName2"   -force
$ComputerName

cd C:\temp
.\test1.ps1 #script scope

$ComputerName #=> DefaultName2


<#







ICE 3 - 

dir Variable: | Format-Table  Name, Value, options  >> C:\temp\vars.txt
$file = dir "C:\temp\vars.txt"
$flSizeText="The size of the file is $([Math]::Round($file.Length/1KB,3)) kilobytes."
#>






# then try 
$windows = "Hello"
.\test1.ps1
$windows
# Notice that we have two seperate scopes 
<# PowerShell normally creates its own variable scope for every script and every function.
You can easily find out how the result would have looked without automatic restrictions on variable
visibility. All you do is type a single dot "." before the script file path to turn off restrictions on
visibility. Type a dot and a space in front of the script: #>

$windows = "Hello"
.\test1.ps1
$windows
. .\test1.ps1
$windows

#Constants that you create in scripts are  write-protected only within the script.
Notepad test2.ps1
# save this into fil
New-Variable a -value 1 -option Constant
"Value: $a"

run file
.\test2.ps1

. .\test2.ps1
$a=2
$a


#####################
### ALL SCOPE

# Test function with its own local variable scope tries to
# redefine the variable $setValue:
Function Test {$setValue = 99; $setValue }

Test

# Read-only variable is created. Test function may modify this
# value nevertheless by creating a new local variable:
New-Variable setValue -option "ReadOnly" -value 200
Test

# Variable is created with the AllScope option and automatically
# copied to local variable scope. Overwriting is now no longer
# possible.
Remove-Variable setValue -force
New-Variable setValue -option "ReadOnly,AllScope" -value 200
Test

Remove-Variable setValue -force
New-Variable setValue -option "AllScope" -value 200
Test

remove-item Function:\Test -force # removes func

# The variable will be created only in the current scope and not
# passed to other scopes. Consequently, it can only be read and
# written in the current scope.
$private:testscope = 1 



# Variables will be created only in the local scope. That is the
# default for variables that are specified without a scope. Local
# variables can be read from scopes originating from the current
# scope, but they cannot be modified.
$local:testscope= 1

# The variable is valid only in a script, but valid everywhere in it.
# Consequently, a function in a script can address other variables,
# which, while defined in a script, are outside the function.
$script:testscope= 1


# The variable is valid everywhere, even outside functions and
# scripts.
$global:testscope= 1


$testscope = 1
$local:testscope

$script:testscope = 12
$global:testscope
$private:testscope


# Define test function:
Function fntest { 
    "variable = $x"; 
    $x = 1000; 
}
# Create variable in console scope and call test function:
$x = 12
fntest #12
# After calling test function, control modifications in console scope:
$x
########################################################
Remove-Variable x -force
New-Variable x -option "AllScope" -value 2000
fntest #1000

$x
########################################################
Remove-Variable x -force
New-Variable x -option "ReadOnly" -value 2000
fntest #2000

$x
#########
Function fntest { 
    "variable = $x"; 
    $global:x = 1000; 
}
# Create variable in console scope and call test function:
$x = 12
fntest
# After calling test function, control modifications in console scope:
$x

$xx=10/5.7
$xx

$xx.GetType().Name
$x = 12
$x.GetType().Name

$xx = 12.5
$xx.GetType().Name

[double]$xd = 12
$xd.GetType().Name


###Variable Types and "Strongly Typing"
(12).GetType().Name

[int32]::MaxValue
[int32]::MinValue


(-100000000000).GetType().Name
[int64]::MaxValue
[int64]::MinValue

(12.5).GetType().Name
(12d).GetType().Name
("H").GetType().Name
(Get-Date).GetType().Name

[Byte]$flag = 12
[Byte]::MaxValue
[Byte]::MinValue

$flag.GetType().Name

[int16]::MinValue
[int16]::MaxValue

$date = "November 12, 2004"
$date
$date.GetType().Name
$date.AddDays(-60)

[datetime]$date = "November 12, 2004"
$date.GetType().Name
$date
$date.AddDays(-60)

#Max/Min of a datatype
#(12).GetType()| Select *

# PowerShell stores a text in XML format as a string:
$t = "<servers>" +
"<server name='Server1' ip='10.10.10.10' user='George' rights='admin'><SW OS='Win2000'/></server>" +
"<server name='Server2' ip='10.10.10.12' user='Mary'><SW OS='Redhat'/></server>" +
"<server name='Server3' ip='10.10.10.13' user='Bob'> <SW OS='CentOS'/></server>" +
"</servers>"

$t

# If you assign the text to a data type[xml], you'll
# suddenly be able to access the XML structure:
[xml]$list = $t
$list.servers

$list.servers.server
$list.servers.server[2].SW

# Even changes to the XML contents are possible:
$list.servers.server[0].ip = "10.10.10.15"
$list.servers.server
$list.servers.server[1].SW = "Redhat"
$list.servers.server[1].SW


$list.servers.server | Where-Object { $_.user -eq "George" }|Select-Object ip

# The result could be output again as text, including the
# modification:
$list.get_InnerXML()


enum CardSuits { 
    Clubs = 0 
    Diamonds = 1 
    Hearts = 2 
    Spades = 3 } 

[CardSuits]$suit = 'Clubs'
[CardSuits]$suit2 = 'Diamonds'
