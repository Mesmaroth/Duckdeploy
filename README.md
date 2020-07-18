# Duckdeploy
This script automates the process of encoding your ducky script, copying the payload to the micro-sd, and ejecting the drive.

**Notice** This script needs to be placed in the root directory of [Hak5's USB-Rubber-Ducky](https://github.com/hak5darren/USB-Rubber-Ducky) repo where `duckencoder.jar` resides.

**Process:**
- Encode ducky script
- Create a 'payloads' folder and move the payload and script in there for organization
- Copy the payload to the drive selected
- (Optional) Eject the drive

# Powershell
**Usage:** 
duckdeploy 

**Or:** duckdeploy -file [file] -drive [drive_letter] -eject [y/n]

**Or:** duckdeploy -deploy [your payload folder] -drive -[drive_letter] - eject [y/n]
- `h`: display help
- `-x`, `deploy`: Deploys the inject.bin to the usb using the folder name of the payload in the payloads folder.
- `-f`,`file`: The ducky script, this must be in the same path as this script.
- `-d`,`drive`: The letter of the drive the payload would be deployed too.
- `-e`,`eject`: Whether or not you want the drive to be ejected for you after this script is finished. Default: No

Tip: If your system does not allow execution of powershell scripts you can try the following: `PS>powershell -ep bypass .\duckdeploy.ps1`

Example:

`PS>.\duckdeploy.ps1`

or

`PS>.\duckdeploy.ps1 -file hello_world.txt -drive d -eject y`

or 

`PS>.\duckdeploy.ps1 -f hello_world.txt -d d -eject y`

Deploy a payload from the payloads folder:

Asumming the payload exit in the payloads folder.
e.g. `./payloads/hello_world/inject.bin`

`PS>.\duckdeploy.ps1 -x windows-hello_world -d d -e y`


# Bash
Usage: duckdeploy
or: duckdeploy -f [file] -d [drive_letter] -e [y/n]
- `h`: display help
- `-x`, `deploy`: Deploys the inject.bin to the usb using the folder name of the payload in the payloads folder.
- `-f`: The ducky script, this must be in the same path as this script.
- `-d`: The letter of the drive the payload would be deployed too.
- `-e`: Whether or not you want the drive to be ejected for you after.

**Note:** Unmounting file systems requires higher privileges. You will be promt when it's time to unmount.

Tip: Use something like `df` or `lsblk` to list the file systems.

`$>chmod +x duckdeploy.sh`

Example:

`$>./duckdeploy.sh`

or

`$>./duckdeploy.sh -f hello_world.txt -d sdb1 -e y`

Deploy a payload from the payloads folder:

Asumming the payload exist in the payloads folder.
e.g. `./payloads/hello_world/inject.bin`

`$>./duckdeploy.sh -x hello_world -d sdb1 -e y`