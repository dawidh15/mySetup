---
author: dawidh15
why: Helpers to setup my-system configuration.
---

# Install-Tools

## Install-Pandoc PowerShell script

This is a script that takes one parameter: `installVersion`. This is the desired version of Pandoc to be installed in your windows system.

The script creates a folder in `<SystemDrive>:\Users\<UserName>\AppData\Temp\PandocTmp`, where the zip file is stored. The next time this script is called, this folder will be deleted and replaced with the chosen version of pandoc.

The Url (https://github.com/jgm/pandoc/releases/download/) is hardcoded. But can be easily changed within the script.

After the zip file is downloaded the script then extracts the file into `<SystemDrive>:\tools\pandoc\pandoc-X.XX`. Afterwards, this folder's path is saved in the *Machine* Environment Variables.

### Usage

Example: You want to install pandoc-2.10 for windows. Then, you should write this line in the PowerShell:

```powerShell
$<This_Repo_Local_Path>\Install-Tools\> .\Install-Pandoc.ps1 -installVersion 2.10
```

### Uninstall

For now, uninstall pandoc manually. Delete the folder `<SystemDrive>:\tools\pandoc\`, clean the `Path`, and delete the Windows Registry where the pandoc key appears (*Careful, do not delete any key from the registry unless you are absolutely sure it is safe to do it*)

## Install-Sqlite PowerShell script

Use this script to download the pre-compiled executables `sqlite3.exe`, `sqldiff.exe` and `sqlite3_analyzer.exe`. The zip file will be downloaded to `$env:Temp\sqliteTMP`. The executables will be installed on `<SystemDrive>:\tools\sqlite\<version>`. And this path will be added to the *Machine* `$env:Path`.

### Usage

Copy the *url* of the binaries, and use it as an argument:

```powershell
> $url="https://www.sqlite.org/2020/sqlite-tools-win32-x86-3320300.zip"
> cd <mySetup_path>\Install-Tools
> .\Install-SQLite.ps1 -precompBins $url
```

If installation was correct, it will prompt you to the *sqlite CLI*. To exit, execute `.quit`

### Uninstall

For now, uninstall sqlite manually. Delete the folder `<SystemDrive>:\tools\sqlite\`, clean the `Path`, and delete the Windows Registry where the pandoc key appears (*Careful, do not delete any key from the registry unless you are absolutely sure it is safe to do it*)

## Install-Miktex

This scripts does the following:

1. Downloads the miktexSetUp.zip from an *URL* provided as an argument to the script (`$urlFile`).
1. Executes `miktexSetUp.exe download`. This downloads the files according to an *installation type* that should be provided in the argument `$installationType`. Accepted values are: `basic, essential, complete`.
1. Executes `miktexSetUp.exe install`. Installation type is replaced with `$installationType` value. This step sets the binaries in System Environment Variables. The installation is shared on all computer users.

First runs using pandoc may failed. Some maintenance is done on the first pandoc trials. User should open *Miktex Console* and update packages as administrator. Scripts should be run as administrator. User may have to provided full path to pdf latex engine on pandocs args during first runs...

Local repository and installation files will be on `<SystemDrive>\tools\miktexSetUp`.

### Usage

```powershell
$url="https://miktex.org/download/ctan/systems/win32/miktex/setup/windows-x64/miktexsetup-4.0-x64.zip"
<Script Path> .\Install-Miktex -urlFile $url -installationType essential
```

### Uninstall

There is a `Uninstall-Miktex.ps1` script that calls (TODO) `miktexSetUp.exe uninstall`.

# Utils

## Test-SHA

This scripts helps to verify if a file was correctly downloaded.

### Example: Check zip file of sqlite for windows

The zip package can be obtained from [here](https://www.sqlite.org/2020/sqlite-tools-win32-x86-3320300.zip). After downloading the file keep the path at hand.

On the website copy the SHA provided by the owners and look at the file hash algorithm. In this case is *SHA1*.

The script has three parameters:

- `-filePath`: The path to the file to be checked.
- `-webSha`: A string with the correct file Hash.
- `-shaAlg`: The hash algorithm.

```powershell
.\Test-SHA.ps1 -webSha e737fe2726bf8cd239e90f1d01b275d5c78a1089 -filePath C:\dev\sqlite\sqlite-tools-win32-x86-3320300.zip -shaAlg SHA1
```

## Generate-Password

Use NET System.Web.Security.Membership method to generate a password.
Special characters, upper and lower cast and non characters are guaranteed. Password length must be specified, and length must be 5 or greater.

### Usage

From the script path:

```
Generate-Password -PasswordLength 8
```