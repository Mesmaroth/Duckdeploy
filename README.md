# Duckdeploy
This script automates the process of encoding your ducky script, copying the payload to the micro-sd, and ejecting the drive.

**Notice** This script needs to be placed in the root directory of [Hak5's USB-Rubber-Ducky](https://github.com/hak5darren/USB-Rubber-Ducky) repo where `duckencoder.jar` resides.

**Process:**
- Encode ducky script
- Create a 'payloads' folder and move the payload and script in there for organization
- Copy the payload to the drive selected
- (Optional) Eject the drive


**TO-DO:**
- duckdeploy Bash script

# Windows
**Usage:** 
duckdeploy 

**Or:** duckdeploy -script [duckyScript] -drive [drive letter] -eject [y/n]
- `h`: display help
- `script`: The ducky script, this must be in the same path as this script.
- `drive`: The letter of the drive the payload would be deployed to
- `eject`: Wether or not you want the drive to be ejected for you after this script is finished. Default: No

Example:

`PS>.\duckdeploy.ps1`

or

`PS>.\duckdeploy.ps1 -script hello_world -drive d -eject y`


