#!/bin/bash
# Author: Robert Sandoval (Mesmaroth)
# Description: Run this script to automate the process of encoding your payload, 
# organizing it on your machine and deploying it to your rubber ducky's micro-sd card.
# duckdeploy.sh -f [file] -d [drive_letter] -e [eject?]


echo "Duckdeploy v1.1"
echo "--------------------"

script=""
no_move=$false

while getopts ':hx:f:d:e:' OPTION; do
    case "$OPTION" in
       h)
        echo "Usage:  duckdeploy.sh"
        echo "   or:  duckdeploy.sh -f [file] -d [drive letter] -e [yes/no]"
        echo 
        echo "Arguments:"
        echo "-x [payload_folder]      Finds and deploys the payload to the mounted usb from the payloads folder."
        echo "-f [file]                The ducky script, this must be in the same path as this script."
        echo "-d [drive letter]        The letter of the drive of where the USB is located. Input only the letter."
        echo "-e [yes/no]              Wether the drive should be ejected after it has been copied over."
        exit 1
        ;;
    x)
        deploy="$OPTARG"    
        ;;
    f)
        script="$OPTARG"
        ;;
    d)
        drive="$OPTARG"
        ;;
    e)
        eject="$OPTARG"
        ;;
    esac
done

function get_drive() {
    for i in {1..4}
    do
        if [[ ! $drive ]]; 
        then
            echo "What is the drive parttion of the USB?"
            read drive_letter
        else
            drive_letter=$drive
        fi
        drive=$(findmnt /dev/$drive_letter | grep / | cut -d ' ' -f1)
        if [[ ! -d $drive ]];
        then
            echo -e "\e[31mERROR: The drive letter \"$drive_letter\" was not found.\e[0m"
        else
            break
        fi

        if [[ i = 4 ]]
        then
            exit 0
        fi
    done
}

function eject_drive() {
        if [[ ! $eject ]];
    then
        echo "Would you like to unmount the drive? (y/n)"
        read eject
    fi
    eject=$(echo $eject | tr '[:upper:]' '[:lower:]')

    if [[ $eject == "y" ]] || [[ $eject == "yes" ]];
    then
        sudo umount /dev/$drive_letter
        echo "Drive \"$drive_letter\" has been unmounted."
    fi
}

if [[ $deploy ]];
then
    if ! [[ -d "./payloads/$deploy" ]];
    then
        echo -e "\e[31mERROR: Folder not found.\e[0m"
        exit
    fi
    if ! [[ -f "./payloads/$deploy/inject.bin" ]];
    then
        echo -e "\e[31mERROR: Inject.bin not found in $deploy folder.\e[0m"
        exit
    fi
    get_drive
    cp ./payloads/$deploy/inject.bin $drive/inject.bin
    echo "Payload $deploy has been deployed to drive \"$drive\""
    sleep 1
    eject_drive
    echo "DONE"
    exit
fi

if ! [[ $script ]]; 
then
    echo "Ducky Script File:"
    read script
fi
script_name=$(echo $script | sed 's/.txt//g')

if [[ ! -d "./payloads" ]];
then
    mkdir "./payloads"
    echo "Payloads directory created"
fi

if [[ ! -f "./$script" ]];
then
    echo  -e "\e[31mERROR: The file \"$script\" was not found. Please try again.\e[0m"
    exit 0yes
    echo "Using script from payloads folder."
    no_move=$true
fi

if [[ ! $no_move ]];
then
    mkdir -p "./payloads/$script_name"
    mv $script ./payloads/$script_name
    echo "Script moved to payloads folder (./payloads/$script_name)"
fi

sleep 0.5

java -jar duckencoder.jar -i ./payloads/$script_name/$script -o ./payloads/$script_name/inject.bin


payload="./payloads/$script_name/inject.bin"
echo "Payload: $payload"; echo 

get_drive
cp $payload $drive
echo "Deployed payload to $drive/inject.bin"
sleep 1
eject_drive
echo "DONE"
exit 0