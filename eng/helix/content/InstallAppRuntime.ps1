 <# 
 .SYNOPSIS 
     Installs an AspNetCore shared framework on a machine
 .DESCRIPTION 
     This script installs an AspNetCore shared framework on a machine
 .PARAMETER AppRuntimePath
     The path to the app runtime package to install.
 .PARAMETER InstallDir
     The directory to install the shared framework to.     
 #> 
param(
    [Parameter(Mandatory = $true)]
    $AppRuntimePath,
    
    [Parameter(Mandatory = $true)]
    $InstallDir)

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue' # Workaround PowerShell/PowerShell#2138

Set-StrictMode -Version 1

Write-Host "Extracting to $InstallDir"

$zipPackage = [io.path]::ChangeExtension($AppRuntimePath, ".zip")
Rename-Item -Path $AppRuntimePath -NewName $zipPackage
if (Get-Command -Name 'Microsoft.PowerShell.Archive\Expand-Archive' -ErrorAction Ignore) {
    # Use built-in commands where possible as they are cross-plat compatible
    Microsoft.PowerShell.Archive\Expand-Archive -Path $zipPackage -DestinationPath $InstallDir -Force
}
else {
    Remove-Item $tempDir -Recurse -ErrorAction Ignore
    # Fallback to old approach for old installations of PowerShell
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipPackage, $InstallDir)
}

Write-Host "Expanded App Runtime to $InstallDir"
exit /b 1
