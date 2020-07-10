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

# Powershell
**Usage:** 
duckdeploy 

**Or:** duckdeploy -file [file] -drive [letter] -eject [y/n]
- `h`: display help
- `-f`,`file`: The ducky script, this must be in the same path as this script.
- `-d`,`drive`: The letter of the drive the payload would be deployed to
- `-e`,`eject`: Wether or not you want the drive to be ejected for you after this script is finished. Default: No

Tip: If your system does not allow execution of powershell scripts you try the following: `PS>powershell -ep bypass .\duckdeploy.ps1`

Example:

`PS>.\duckdeploy.ps1`

or

`PS>.\duckdeploy.ps1 -file hello_world.txt -drive d -eject y`

or 

`PS>.\duckdeploy.ps1 -f hello_world.txt -d d -eject y`


