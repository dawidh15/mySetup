   Param(
    [Parameter(Mandatory=$true)]
    [String]$installVersion
    )

Function Main
{
# Construct Path for download
Set-Variable -Name "PandocFolderName" -Value "PandocTmp\"
Set-Variable -Name "PandocPath" -Value (Join-Path $env:TMP $PandocFolderName)
Write-Host "Path Name Created: " $PandocPath

# Check if Temp Folder for Download exists
# Yes: Delete folder and everything inside
If (Test-Path $PandocPath)
  {
    Remove-Item $PandocPath -Recurse
    Write-Host "Folder found and then deleted."
  }

# Create Folder
New-Item -Path $PandocPath -Type Directory

# Web request for Pandoc.zip
    # Construct names, paths
Set-Variable -Name "PandocZip" -Value ("/pandoc-" + $installVersion + "-windows-x86_64.zip")
Set-Variable -Name "SourceZip" -Value ("https://github.com/jgm/pandoc/releases/download/" + $installVersion + $PandocZip)
Write-Host "Powershell generated Url: " + $SourceZip
Set-Variable -Name "LocalTempZip" -Value ($PandocPath + $PandocZip)

Invoke-WebRequest $SourceZip -OutFile $LocalTempZip

If(Test-Path $LocalTempZip)
{
    Write-Host "File downloaded in: " + $PandocPath
} else {
       Write-Host "File was NOT downloaded. Check True Url, against powershell generated Url."
       Exit
}

# Unzip
$toolsPandocPath = Get-ToolsPandoc
CreateIf-Folder $toolsPandocPath
Expand-Archive -LiteralPath $LocalTempZip -DestinationPath $toolsPandocPath


# Add Path to env
If(Test-Path $toolsPandocPath)
{
  cd $toolsPandocPath
  $inputPath = (Join-Path $toolsPandocPath (Get-ChildItem -Name) )
  $inputPath += "\" #This is needed!
  Set-pandocOnEnv $inputPath

} else {

  Write-Host "Problem with installation folder. Not Found. Could not set pandoc to ENV."
}


# Test correct installation
Write-Host "To test installation, RESTART your PC, open PowerShell and call: pandoc --version"

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
        Write-Host "Old folder was removed:" + $sPath
    } else {
        New-Item -Path $sPath -ItemType Directory
        Write-Host "Folder Created at: " + $sPath
    }
}

# Create Path <SystemDrive>:\tools\pandoc
Function script:Get-ToolsPandoc{
    # Create Path on SystemDrive
    Set-Variable -Name "ToolsPandocPath" -Value  (Join-Path $env:SystemDrive "\tools\pandoc")
    $ToolsPandocPath
}

# Set pandoc-installVersion on system path.
Function script:Set-pandocOnEnv{
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


# Call Main function
Main
