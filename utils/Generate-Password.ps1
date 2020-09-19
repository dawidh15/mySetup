# http://woshub.com/generating-random-password-with-powershell/#:~:text=If%20you%20do%20not%20want,using%20a%20simple%20PowerShell%20script.&text=The%20GeneratePassword%20method%20allows%20to%20generate%20a%20password%20up%20to%20128%20characters.
Param(
[Parameter(Mandatory=$true)][int]$PasswordLength
)

Function Main
{
If ($PasswordLength -lt 5)
{
    Write-Host "PasswordLength must be greater than 4"
    Exit
}

Add-Type -AssemblyName System.Web
$PassComplexCheck = $false
do {
$newPassword=[System.Web.Security.Membership]::GeneratePassword($PasswordLength,1)
If ( ($newPassword -cmatch "[A-Z\p{Lu}\s]") `
-and ($newPassword -cmatch "[a-z\p{Ll}\s]") `
-and ($newPassword -match "[\d]") `
-and ($newPassword -match "[^\w]")
)
{
$PassComplexCheck=$True
}
} While ($PassComplexCheck -eq $false)
return $newPassword
}

Main