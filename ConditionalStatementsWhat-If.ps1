<#

Read pg 206 table of operators

#>
4 -eq 10 # equal to
"secret" -ieq "SECRET"

123 -lt 123.5 # less than

$a = 10
$a -gt 5

-not ($a -gt 5) 

# Shorthand: instead of -not "!" can also be used:
!($a -gt 5)

( ($age -ge 18) -and ($sex -eq "m") )

<#
logical operators pg 210


#>

#In the simplest case, use the comparison operator -eq (equal) to find all elements in an array equal to the specified value
1,2,3,4,3,2,1 -eq 3
1,2,3,4,3,2,1 -ne 3


# -eq returns only those elements matching the criterion:
1,2,3 -eq 5
# -contains answers the question of whether the sought element is included in thearray:

1,2,3 -contains 5 
1,2,3 -notcontains 5

# pipeline filtering
Get-Process | Select-Object -first 1 | Format-List *

#The $_ variable contains the current pipeline object
Get-Process | Where-Object { $_.name -eq 'Calculator' }

Get-Process | Where-Object { $_.company -like 'micro*' } | Format-Table name, description, company


# Attention: all instances of Notepad will be terminated
# immediately and without further notification:
Get-Process | Where-Object { $_.name -eq 'notepad' } | Foreach-Object { $_.Kill() }
notepad.exe


Get-Process | ?{ $_.name -eq 'notepad' } | Foreach-Object { $_.Kill() }

#an alias exists for Where-Object: "?"
# The two following instructions return the same result:
# all running services
Get-Service | ForEach-Object {$_.Status -eq 'Running' }
Get-Service | ? {$_.Status -eq 'Running' }

# IF ELSE
If (condition) {
    # If the condition applies,
    # this code will be executed
   }
   
 
   $a = 11
   If ($a -gt 10) { "$a is larger than 10" } 

   $a = 9
If ($a -gt 10)
{
 "$a is larger than 10"
}
Else
{
 "$a is less than or equal to 10"
}

# more...
$a = 10
If ($a -gt 10)
{
 "$a is larger than 10"
}
ElseIf ($a -eq 10)
{
 "$a is exactly 10"
}
Else
{
 "$a is less than 10"
}


<#

The If statement here always executes the code in the braces after the condition that is met. The
code after Else will be executed when none of the preceding conditions are true. What happens if
several conditions are true? Then the code after the first applicable condition will be executed and all
other applicable conditions will be ignored.

#>


$a=10
# and even more..
If ($a -gt 10)
{
 "$a is larger than 10"
}
ElseIf ($a -eq 10)
{
 "$a is exactly 10"
} 
ElseIf ($a -ge 10)
{
 "$a is larger than or equal to 10"
}
Else
{
 "$a is smaller than 10"
}


#switch statement # Test a value against several comparison values (with Switch statement):
$value = 1
Switch ($value)
{
 1 { "Number 1" }
 2 { "Number 2" }
 3 { "Number 3" }
}

# a little more...

$value = 50
Switch ($value)
{
 {$_ -le 5} { "$_is a number from 1 to 5" }
 6 { "Number 6" }
 {(($_ -gt 6) -and ($_ -le 10))}
 { "$_ is a number from 7 to 10" }
 # The code after the next statement will be
 # executed if no other condition has been met:
 default {"$_ is a number outside the range from 1 to 10" }
}


# NOTE: If more than one condition applies, then Switch will behave differently than If. For If, only the first
<# applicable condition was executed. For Switch, all applicable conditions are executed:#>
$value = 50
Switch ($value)
{
    50 { "the number 50" }
    {$_ -gt 10} {"larger than 10"}
    {$_ -is [int]} {"Integer number"}
   }
   
   # write a switch statement that tells a student if they pass or fail
   # create an input array with the following grades {25, 35, 55, 65, 85, 100}
   # the pass garde is >=65


$value = 50.0
Switch ($value)
{
    50 { "the number 50" }
    {$_ -gt 10} {"larger than 10"}
    {$_ -is [int]} {"Integer number"} #<--Whats the issue
   }
   
#case sensitivity
   $action = "sAVe"
Switch -case ($action)
{
 "save" { "I save..." }
 "open" { "I open..." }
 "print" { "I print..." }
 Default { "Unknown command" }
}


#Wildcard Characters


$text = "IP address: 10.10.10.10"
Switch -wildcard ($text)
{
 "IP*" { "The text begins with IP: $_" }
 "*.*.*.*" { "The text contains an IP " + "address string pattern: $_" }
 "*dress*" { "The text contains the string " + "'dress' in arbitrary locations: $_" }
}


# regex switch
$text = "IP address: 10.10.10.10"
Switch -regex ($text)
{
 "^IP" { "The text begins with IP: " + "$($matches[0])" }
 "\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}" { "The text contains an IP address " + "string pattern: $($matches[0])" }
 "\b.*?dress.*?\b" { " The text " + "contains the string 'dress' in " + "arbitrary locations: $($matches[0])" }
}

#Process several vals
$array = 1..5
Switch ($array) # ICE Build Func
{
 {$_ % 2} { "$_ is odd."}# mod
 Default { "$_ is even."}
}
$inp=Get-Process 
$inp.GetType()

# script block (&{...}).
Get-Process | &{Switch($input) { {$_.WS -gt 1MB} { $_ }}}
Get-Process | Where-Object { $_.WS -gt 1MB }
Get-Process | ? { $_.WS -gt 1MB }
<#This variant is also quicker because Switch had to wait until the pipeline had collected the entire
results of the preceding command in $input. In Where-Object, it processes the results of the
preceding command precisely when the results are ready. #>


# Switch returns all files beginning with "a":
Dir | & { Switch($input) { {$_.name.StartsWith("a")} { $_ } }}

# But it doesn't do so until Dir has retrieved all data, and that can take a long time:
Dir -Recurse | & { Switch($input) {{$_.name.StartsWith("a")} { $_ } }}

# Where-Object processes the incoming results immediately:
Dir -recurse | Where-Object {$_.name.StartsWith("a") }

# The alias of Where-Object ("?") works# exactly the same way:
Dir -recurse | ? { $_.name.StartsWith("a") }
