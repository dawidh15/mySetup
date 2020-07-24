   Param(
    [Parameter(Mandatory=$true)]
    [String]$precompBins
    )

Function Main
{
# Construct Path for download
Set-Variable -Name "sqliteFolderName" -Value "sqliteTmp\"
Set-Variable -Name "sqlitePath" -Value (Join-Path $env:TMP $sqliteFolderName)
Write-Host "Path Name Created: " $sqlitePath

# Check if Temp Folder for Download exists
# Yes: Delete folder and everything inside
If (Test-Path $sqlitePath)
  {
    Remove-Item $sqlitePath -Recurse
    Write-Host "Old Folder found and then deleted. New folder created."
  }

# Create Folder
New-Item -Path $sqlitePath -Type Directory

# Web request for sqlite.zip
    # Construct names, paths
Set-Variable -Name "sqliteZip" -Value (Split-Path $precompBins -Leaf)
Set-Variable -Name "SourceZip" -Value $precompBins
Write-Host "Powershell generated Url: " $SourceZip
Set-Variable -Name "LocalTempZip" -Value ($sqlitePath + $sqliteZip)

Invoke-WebRequest $SourceZip -OutFile $LocalTempZip

If(Test-Path $LocalTempZip)
{
    Write-Host "File downloaded in: " + $LocalTempZip
} else {
       Write-Host "File was NOT downloaded. Check True Url, against powershell generated Url."
       Exit
}

# Unzip
$toolsPath = Get-ToolsSqlite
CreateIf-Folder $toolsPath
Expand-Archive -LiteralPath $LocalTempZip -DestinationPath $toolsPath


# Refresh path
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User") 

# Add Path to env
If(Test-Path $toolsPath)
{
  cd $toolsPath
  $inputPath = (Join-Path $toolsPath (Get-ChildItem -Name) )
  $inputPath += "\" #This is needed!
  Set-OnEnv $inputPath

} else {

  Write-Host "Problem with installation folder. Not Found. Could not set pandoc to ENV."
}


# Refresh path
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User") 

# Test correct installation
Start-Process -FilePath "sqlite3.exe" -ArgumentList "ex1" -Wait

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
Function script:Get-ToolsSqlite{
    # Create Path on SystemDrive
    Set-Variable -Name "ToolsSqlitePath" -Value  (Join-Path $env:SystemDrive "\tools\sqlite")
    $ToolsSqlitePath
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


# Call Main function
Main
