Param(
 [Parameter(Mandatory=$true)]
 [String]$urlFile,
 [Parameter(Mandatory=$true)]
 [String]$installationType
 )
# installationType In basic, essential, complete
# https://miktex.org/download/ctan/systems/win32/miktex/setup/windows-x64/miktexsetup-4.0-x64.zip
Function Main
{
# Construct Path for download
Set-Variable -Name "tmpFolder" -Value "miktexSetUp\"
Set-Variable -Name "tmpPath" -Value (Join-Path $env:TMP $tmpFolder)
Write-Host "Path Name Created: " $tmpPath

# Check if Temp Folder for Download exists
# Yes: Delete folder and everything inside
If (Test-Path $tmpPath)
{
 Remove-Item $tmpPath -Recurse -Force
 Write-Host "Old Folder found and then deleted. New folder created."
}

# Create Folder
New-Item -Path $tmpPath -Type Directory

# Web request for miktexSetUp
 # Construct names, paths
Set-Variable -Name "miktexSetUpZip" -Value (Split-Path $urlFile -Leaf)
Write-Host "Powershell generated Url: " $urlFile
Set-Variable -Name "LocalTempZip" -Value (Join-Path $tmpPath $miktexSetUpZip)

Invoke-WebRequest $urlFile -OutFile $LocalTempZip

If(Test-Path $LocalTempZip)
{
 Write-Host "File downloaded in: " + $LocalTempZip
} else {
    Write-Host "File was NOT downloaded. Check True Url, against powershell generated Url."
    Exit
}

# Unzip
$toolsPath = Get-ToolsMiktexSetUp
CreateIf-Folder $toolsPath
Expand-Archive -LiteralPath $LocalTempZip -DestinationPath $toolsPath -Force


# Refresh path
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# Add Path to env
If(Test-Path $toolsPath)
{
cd $toolsPath
#$inputPath = (Join-Path $toolsPath (Get-ChildItem -Name) )
$inputPath = $toolsPath
$inputPath += "\" #This is needed!
Set-OnEnv $inputPath

} else {

Write-Host "Problem with installation folder. Not Found. Could not set pandoc to ENV."
}


# Refresh path
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# Set installation paths
$localRepoFolder = "localRepo"
$localConfigFolder = "config"
$localDataFolder = "data"
$localInstallFolder = "install"

# Downdload Repo
Download-MiktexRepository

# Move executable to repo (required to install step)
Copy-SetUpToRepo

# Install Repo
Install-MiktexRepository

# Refresh path
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

} # End Main


# ==============  HELPER FUNCTIONS =========================

#Create folder, if exist delete, then create
Function script:CreateIf-Folder{
 Param(
 [Parameter(Mandatory=$true)]
 [String]$sPath
 )

 If(Test-Path $sPath)
 {
     # Only need one installation folder, for correct path definition
     Remove-Item $sPath -Recurse
     Write-Host "Old folder was removed: " $sPath
 } else {
     New-Item -Path $sPath -ItemType Directory
     Write-Host "Folder Created at: " $sPath
 }
}

# Create Path <SystemDrive>:\tools\sqlite
Function script:Get-ToolsMiktexSetUp{
 # Create Path on SystemDrive
 Set-Variable -Name "ToolstmpPath" -Value  (Join-Path $env:SystemDrive "\tools\miktexSetUp")
 $ToolstmpPath
}

# Set pandoc-installVersion on system path.
Function script:Set-OnEnv{
Param(
 [Parameter(Mandatory=$true)]
 [String]$sPath
 )

 $NotOnPath = -not($env:Path -match (Split-Path $sPath -Leaf) )
   If( $NotOnPath ){
     $pathElements = @([Environment]::GetEnvironmentVariable("Path", "Machine") -split ";")
     $pathElements += $sPath
     $newPath = $pathElements -join ";"
     [Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")
     Write-Host $sPath " was added to env:Path."

} else {

 Write-Host "Path already on env:Path " $sPath

}

# Modified from Holmes, Lee. Windows PowerShell Cookbook . O'Reilly Media. Edición de Kindle.
}


# Copy miktexsetup.exe to repo
Function script:Copy-SetUpToRepo{
    $setupName = Get-ChildItem -Path $toolsPath -include "miktexsetup*"
    $destination = (Join-Path $toolsPath $localRepoFolder)
    Copy-Item -Path $setupName.FullName -Destination $destination
}


# Download repo
Function script:Download-MiktexRepository{
    $DownloadExpression="miktexsetup --verbose --local-package-repository="
    $DownloadExpression += (Join-Path $toolsPath $localRepoFolder)
    $DownloadExpression += (" --package-set=" + $installationType)
    $DownloadExpression += " --shared download"
    Write-Host $DownloadExpression
    Invoke-Expression $DownloadExpression
}

# Install Miktex Repository
Function script:Install-MiktexRepository{
$InstallExpression="miktexsetup --verbose --local-package-repository="
$InstallExpression += (Join-Path $toolsPath $localRepoFolder)
$InstallExpression += " --common-config="
$InstallExpression += (Join-Path $toolsPath $localConfigFolder)
$InstallExpression += " --common-data="
$InstallExpression += (Join-Path $toolsPath $localDataFolder)
$InstallExpression += " --common-install="
$InstallExpression += (Join-Path $toolsPath $localInstallFolder)
$InstallExpression += " --common-link-target-directory="
$InstallExpression += (Join-Path $toolsPath "install\bin")

# Check install commnad uncheck next line, comment the line after it.
#$InstallExpression += " --shared --print-info-only install"
$InstallExpression += (" --package-set=" + $installationType)
$InstallExpression += " --shared install"

Write-Host $InstallExpression
Invoke-Expression $InstallExpression

}

# Call Main function
Main
