# Get help in: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/get-filehash?view=powershell-7
   Param(
    [Parameter(Mandatory=$true)]
    [String]$webSha,
    [Parameter(Mandatory=$true)]
    [String]$filePath,
    [Parameter(Mandatory=$true)]
    [String]$shaAlg
    )

Function Main
{
# Paste the web sha here
#Set-Variable -Name "webSha" -Value  "e737fe2726bf8cd239e90f1d01b275d5c78a1089"

# Paste the path of the file to verify
#$filePath="C:\dev\sqlite\sqlite-tools-win32-x86-3320300.zip"

# Get the sha of the downloaded file
# Watch for sha algorithm (SHA1, MD5, etc)
Get-FileHash -Path $filePath -Algorithm $shaAlg | Set-Variable -Name "fileHash"

If( ($fileHash.Hash) -eq $webSha )
{
    Write-Host "La descarga fue correcta."
} Else {
    Write-Host "El archivo está corrupto"
    }
}

Main