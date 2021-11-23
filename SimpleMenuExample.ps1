


function createUser(){
Clear-Host;
Write-Host "Createing User...";

}

Clear-Host;

Do {


Write-Host " ***************************"
Write-Host " *           Menu          *"
Write-Host " ***************************"
Write-Host
Write-Host " 1. Create User"
Write-Host " 2. Create Group"
Write-Host " 3. Add User to Group"
Write-Host " 4. Change Password"
Write-Host " 5. Quit"
Write-Host
Write-Host " Select an option and press Enter: " -nonewline

$Select = Read-Host
Switch ($Select)
    {
    1 { createUser}
    2 { Commands to be run if user selects menu option 2}
    3 { Commands to be run if user selects menu option 3}
    4 { Commands to be run if user selects menu option 4}
    }
}
While ($Select -ne 5)


