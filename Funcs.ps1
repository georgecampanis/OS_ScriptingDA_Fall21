
#first Fn
Function myPing { ping.exe -w 100 -n 5 10.0.0.13 }
myPing


# with args
Function myPing { ping.exe -w 100 -n 3 $args }
#https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/ping
myPing $env:COMPUTERNAME
#www.google.com


# The next two commands both store the content of the tabexpansion function in a file:
#https://docs.microsoft.com/en-us/powershell/scripting/learn/using-tab-expansion?view=powershell-7.1
${function:New-Guid} | Out-File "C:\temp\guidOut.ps1"
#$function:tabexpansion > myscript.ps1



# Notepad opens the file:
# You can specify the name of the file after notepad, but $$ is shorter and easier. This special variable always contains the last token of
# the last pipeline. In this case, the last token was the name of the file.
notepad $$


Set-Item function:test {
    "This function can neither be deleted nor modified."} -option  constant
   test

   Remove-Item function:test
  
   function Howdy {
       #($args -ne $null)=> ($args != null)
    If ($args -ne $null) 
    {
    "You specified: $args"
    "Argument number: $($args.count)"
    $args | ForEach-Object { $i++; "$i. Argument: $_" }
    } Else {
    "You haven't specified any arguments!"
    }
   }

   # The function notices when you haven't specified any arguments:
Howdy
Howdy "George"
Howdy "George" "Mary"
Howdy George Mary Bob Peter



function testArrayFn {
    Foreach ($element in $args) {
    $i++
    If ($element -is [array]) {
    "$i. Argument is an array: $element"
    } Else {
    "$i. Argument is not an array: $element"
    }
    }
   }
   
   testArrayFn Hello test test2


   function SaySomething {
    # No argument was given:
    If ($args -eq $null)
    {
    "No arguments"
    # An array was specified as the first argument,
    # so the function calls itself again
    # for every argument in the array:
    }
    ElseIf ($args[0] -is [array])
    {
    Foreach ($element in $args[0])
    {
    SaySomething $element
    }
    # The first argument is not an array; the actual task was not completed:
    }
    Else
    {
    "Howdy, $args"
    }
   }
   

   SaySomething Tobias
   SaySomething Tobias, Martina, Cof #array

   #If you'd like to refer to certain arguments, just remember again that $args is an array.

function Add{ $args[0] + $args[1]}
Add 1 2
Add 1, 2 # will run seperately

# setting paras
function Add {
    $Value1, $Value2 = $args
    $Value1 + $Value2
    }
    Add 1 6

    # NOPE
    Add 1 2 3

    Function subtract($Value1, $Value2) {
        $value1 - $value2
         }
        Subtract 5 2
        

# Named arguments can be assigned using parameters;
# a fixed sequence isn't necessary:
Subtract -Value1 12 2

Subtract -Value2 12 2

# Unnecessary arguments will be ignored:
Subtract 5 2 3


# This function won't accept any optional arguments:
function Subtract ($Value1, $Value2)
{
 # Verify whether there are additional inputs;
 # if yes, generate an error message:
 If ($args.Count -ne 0) {
 Throw "I don't need any more than just two arguments." }
 $value1 - $value2
}
Subtract 1 2

Subtract 1 2 3

#####    => ended pg 255

########################## 
# Scripts
##########################
' "Hello world" ' > C:\temp\myscript2.ps1
' "Hello world" ' >> C:\temp\myscript2.ps1

C:\temp\myscript2.ps1 # error
Get-ExecutionPolicy
Set-ExecutionPolicy RemoteSigned # run with admin
C:\temp\myscript.ps1 # fixed - open with admin

@'
"Hello world"
"One more line"
Get-Process
Dir
'@ > C:\temp\myscript.ps1

Notepad C:\temp\myscript.ps1

Set-Alias mycmd C:\temp\myscript2.ps1 # like a cmd

mycmd

# md, copy

# $args Returns All Arguments
'"Hello, $args!"'  > C:\temp\myscript.ps1
C:\temp\myscript.ps1 George

#$args is an Array
# Spaces separate arguments. Several spaces
# following each other are combined into one:
C:\temp\myscript.ps1 This          text has a lot of spaces!

C:\temp\myscript.ps1 "This          text has a lot of spaces!"

'"Hello, $($args[0])!"' > C:\temp\myscript.ps1
C:\temp\myscript.ps1 George Campanis

'"Hello, $($args[1])!"' > C:\temp\myscript.ps1
C:\temp\myscript.ps1 George Campanis


# using para in scripts
<# 
param($path, $name)
"The path is: $path"
"The name is: $name" 
#>

notepad C:\temp\myscript.ps1

C:\temp\myscript.ps1 "the path" "the name"
C:\temp\myscript.ps1 -name "the name" -path "the path"

<# 
param([string]$Name=$( `
 Throw "Parameter missing: -name Name"),
 [int]$age=$( `
 Throw "Parameter missing: -age x as number")) `
 "Hello $name, you are $age years old!" 
 #>






 C:\temp\myscript3.ps1
 C:\temp\myscript3.ps1 -name George
 C:\temp\myscript3.ps1 -name George C
 C:\temp\myscript3.ps1 -name George 48

 ### end pg 288
 


