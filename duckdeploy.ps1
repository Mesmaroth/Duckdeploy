# Author: Robert Sandoval (Mesmaroth)
# Description: Run this script to automate the process of encoding your payload, 
# organizing it on your machine and deploying it to your rubber ducky's micro-sd card.
# duckenploy.ps1 [script_name] [drive_letter] [eject?]

param (
    [string]$script = "",
    [string]$drive = "",
    [string]$eject = "n",
    [switch]$help
)

Write-Output "Duckdeploy v1.0"
Write-Output "---------------"

if($help) {
    Write-Output "Usage:  duckdeploy.ps1"
    Write-Output "   or:   duckdeploy.ps1 -script [file] -drive [drive letter] - eject [yes/no]"
    Write-Output "`n"
    Write-Output "Arguments:"
    Write-Output "-script [file]                The ducky script, this must be in the same path as this script"
    Write-Output "-drive [drive letter]         The letter of the drive of where the USB is located. Input only the letter"
    Write-Output "-eject [yes/no]               Wether the drive should be ejected after it has been copied over."
    exit
}

if($script) {
    $payload_name = $script
} else {
    $payload_name = Read-Host 'Payload name ending in .txt? (Must be within the same directory as this script)'
}

$payload_file = $payload_name + ".txt"
if(-Not (Test-Path .\$payload_file)) {
    Write-Output "ERROR: The file `"${payload_file}`" was not found. Please try again."
    exit
}

if(-Not (Test-Path .\payloads\)) {
    mkdir .\payloads | Out-Null
    Write-Output "Payloads directory created."
}
mkdir -Force .\payloads\$payload_name | Out-Null
Write-Output "Encoding your script."
java -jar .\duckencoder.jar -i .\$payload_file -o .\payloads\$payload_name\inject.bin
Move-Item $payload_file .\payloads\$payload_name\
Write-Output "Script moved to payloads folder (.\payloads\$payload_name)"
$payload_file = ".\payloads\" + $payload_name + "/inject.bin"

for($i = 0; $i -le 3; $i++) {
    if($drive){
        $drive_letter = $drive
    } else {
        $drive_letter = Read-Host 'What is the drive letter of the USB? (Letter only)'
    }
    $drive_letter = $drive_letter.ToUpper() + ":"
    if(-Not (Test-Path $drive_letter)) {
        Write-Output "ERROR: The drive letter `"${drive_letter}`" was not found."
        $drive = $null 
    } else {
        break
    }
    if($i -eq 3) {
        exit
    }
}
Copy-Item $payload_file $drive_letter
Write-Output "Copied payload to ${drive_letter}\inject.bin"
Start-Sleep -m 1000
if($eject){
    $eject = $eject
} else {
    $eject = Read-Host "Would you like to eject the drive? (y/n)"
}
$eject = $eject.ToLower()

if( $eject -eq "y" -Or $eject -eq "yes" -Or $eject -eq $true){
    Write-Output "Ejecting..."
    $driveEject = New-Object -comObject Shell.Application
    $driveEject.NameSpace(17).ParseName($drive_letter).InvokeVerb("Eject")
    Write-Output "Drive `"${drive_letter}`" has been ejected."
}

Write-Output "DONE"
exit
