param (
    [Parameter(Mandatory=$true)]
    [string]$firstname = "George",

    [Parameter(Mandatory=$true)]
    [string]$lastname = "Campanis"
)

$datetimeout = Get-Date

$mystring= $firstname + " " + $lastname + "     " + $datetimeout

$mystring >> C:\temp\outfile.txt

# end of script file
