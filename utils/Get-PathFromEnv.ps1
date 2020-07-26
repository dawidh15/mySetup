# Get a full path from a matching patter in $env:path
Param(
 [Parameter(Mandatory=$true)]
 [String]$pattern
 )

Function script:Main{
  $env:Path.Split(";") | ForEach-Object {
    if ($_ -match $pattern)
        {
        $path = $_
        }
}

Write-Host $path
}

Main
