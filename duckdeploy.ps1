# Author: Robert Sandoval (Mesmaroth)
# Description: Run this script to automate the process of encoding your payload, 
# organizing it on your machine and deploying it to your rubber ducky's micro-sd card.
# duckdeploy.ps1 [file] [drive_letter] [eject?]

param (
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

Write-Host "Duckdeploy v1.0"
Write-Host "---------------"

if($help) {
    Write-Host "Usage:  duckdeploy.ps1"
    Write-Host "   or:  duckdeploy.ps1 -f [file] -d [drive letter] -e [yes/no]"
    Write-Host "`n"
    Write-Host "Arguments:"
    Write-Host "-f, -file [file]                The ducky script, this must be in the same path as this script"
    Write-Host "-d, -drive [drive letter]       The letter of the drive of where the USB is located. Input only the letter"
    Write-Host "-e, -eject [yes/no]             Wether the drive should be ejected after it has been copied over."
    exit
}

$no_move = $false

if(-Not ($script)) {
    $script = Read-Host 'Ducky Script File: '
}
$script = $script.trim(".\")
$script_name = $script.trim(".txt")
if(-Not (Test-Path .\payloads\)) {
    mkdir .\payloads | Out-Null
    Write-Output "Payloads directory created."    
}

if(-Not (Test-Path .\$Script)) {
    Write-Host "ERROR: The file `"${script}`" was not found. Please try again." -ForegroundColor Red
    exit
} elseif (Test-Path ".\payloads\$script_name\$script") {
    Write-Output "FOUND existing script in payloads folder.`nUsing script from payloads folder.`n"
    $no_move = $true
} 

if(-Not($no_move)) {
    mkdir -f .\payloads\$script_name | Out-Null
    Move-Item $script .\payloads\$script_name\
    Write-Output "Script moved to payloads folder (.\payloads\$script_name)"
}
Start-Sleep -m 1000
Write-Host "Encoding script..."
try{
    java -jar .\duckencoder.jar -i .\payloads\$script_name\$script -o .\payloads\$script_name\inject.bin
} catch {
    exit
}

$payload = ".\payloads\" + $script_name + "\inject.bin"
Write-Host "Payload: ${payload}`n"

for($i = 0; $i -le 3; $i++) {
    if($drive){
        $drive_letter = $drive
    } else {
        $drive_letter = Read-Host 'What is the drive letter of the USB? (Letter only)'
    }
    $drive_letter = $drive_letter.ToUpper() + ":"
    if(-Not (Test-Path $drive_letter)) {
        Write-Host "ERROR: The drive letter `"${drive_letter}`" was not found." -ForegroundColor Red
        $drive = $null 
    } else {
        break
    }
    if($i -eq 3) {
        exit
    }
}

Copy-Item $payload $drive_letter
Write-Output "Deployed payload to ${drive_letter}\inject.bin"
Start-Sleep -m 1000
if(-Not ($eject)){
    $eject = Read-Host "Would you like to eject the drive? (y/n)"
}
$eject = $eject.ToLower()

if( $eject -eq "y" -Or $eject -eq "yes" -Or $eject -eq $true){
    Write-Output "Ejecting..."
    $driveEject = New-Object -comObject Shell.Application
    $driveEject.NameSpace(17).ParseName($drive_letter).InvokeVerb("Eject")
    Write-Output "Drive `"${drive_letter}`" has been ejected."
}

Write-Host "DONE"
exit
