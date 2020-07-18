# Author: Robert Sandoval (Mesmaroth)
# Description: Run this script to automate the process of encoding your payload, 
# organizing it on your machine and deploying it to your rubber ducky's micro-sd card.
# duckdeploy.ps1 [file] [drive_letter] [eject?]

param (
    [Alias("x")]
    [string]$deploy,
    [Alias("file")]
    [Alias("f")]
    [Alias("s")]
    [string]$script,
    [Alias("d")]
    [string]$drive,
    [Alias("e")]
    [ValidateSet('y', 'n', 'yes', 'no')][string]$eject,
    [Alias("h")]
    [switch]$help
)

Write-Host "Duckdeploy v1.2"
Write-Host "Written by Mesmaroth"
Write-Host "--------------------"

if($help) {
    Write-Host "Usage:  duckdeploy.ps1"
    Write-Host "   or:  duckdeploy.ps1 -f [file] -d [drive letter] -e [yes/no]"
    Write-Host "`n"
    Write-Host "Arguments:"
    Write-Host "-x, -deploy [existing payload name]  Finds and deploys the payload to the mounted usb from the payloads folder."
    Write-Host "-f, -file [file]                     The ducky script, this must be in the same path as this script."
    Write-Host "-d, -drive [drive letter]            The letter of the drive of where the USB is located. Input only the letter."
    Write-Host "-e, -eject [yes/no]                  Wether the drive should be ejected after it has been copied over."
    exit
}

function Get-Drive() {
    for($i = 0; $i -le 3; $i++) {
        if(-Not ($drive)){
            $drive = Read-Host 'What is the drive letter of the USB? (Letter only)'
            $drive = $drive.ToUpper() + ":"
        } else {
            $drive = $drive.ToUpper() + ":"
        }        
        if(-Not (Test-Path ${drive})) {
            Write-Host "ERROR: The drive `"${drive}`" was not found." -ForegroundColor Red
            $drive = $null 
        } else {
            break
        }
        if($i -eq 3) {
            exit
        }
    }
    return $drive
}

function Eject-Drive() {
    if(-Not ($eject)){
        $eject = Read-Host "Would you like to eject the drive? (y/n)"
    }
    $eject = $eject.ToLower()    
    if( $eject -eq "y" -Or $eject -eq "yes" -Or $eject -eq $true){
        $drive=$drive.ToUpper()
        Write-Output "Ejecting..."
        $driveEject = New-Object -comObject Shell.Application
        $driveEject.NameSpace(17).ParseName("${drive}").InvokeVerb("Eject")
        Write-Output "Drive `"${drive}`" has been ejected."
    }    
}

if($deploy) {
    if(-Not (Test-Path .\payloads\$deploy)){
        Write-Host "ERROR: Folder not found." -ForegroundColor Red
        exit
    }
    if(-Not (Test-Path .\payloads\$deploy\inject.bin)){
        Write-Host "ERROR: inject.bin not found in $deploy folder." -ForegroundColor Red
        exit
    }
    $drive=Get-Drive
    cp .\payloads\$deploy\inject.bin ${drive}\inject.bin
    Write-Host "Payload ${deploy} has been deployed to drive `"$($drive.ToUpper())`".`n"
    Start-Sleep 1
    Eject-Drive
    Write-Host "DONE"
    exit
}

if(-Not (Test-Path .\payloads\)) {
    mkdir .\payloads | Out-Null
    Write-Output "Payloads directory created."    
}

if(-Not ($script)) {
    $script = Read-Host 'Ducky Script File: '
}
$no_move = $false
if(-Not (Test-Path $Script)) {
    Write-Host "ERROR: The file `"${script}`" was not found. Please try again." -ForegroundColor Red
    exit
} 
$script_name = (Get-Item $script).BaseName 
if (Test-Path ".\payloads\$script_name\$script") {
    Write-Output "FOUND existing script in payloads folder.`nUsing script from payloads folder.`n"
    $no_move = $true
}

if(-Not($no_move)) {
    mkdir -f .\payloads\$script_name | Out-Null
    Move-Item $script .\payloads\$script_name\
    Write-Output "Script moved to payloads folder (.\payloads\$script_name)"
}
Start-Sleep 1
Write-Host "Encoding script..."
try{
    java -jar .\duckencoder.jar -i .\payloads\$script_name\$script -o .\payloads\$script_name\inject.bin
} catch {
    exit
}
$payload = ".\payloads\" + $script_name + "\inject.bin"
Write-Host "Payload: ${payload}`n"
$drive=Get-Drive
Copy-Item $payload ${drive}\
Write-Output "Deployed payload to ${drive}\inject.bin"
Start-Sleep 1
Eject-Drive
Write-Host "DONE"
exit
