#!/usr/bin/env zsh

LOCK_FILE_NAME="dmenu_wifi.lock"
LOCK_FILE_PATH="/tmp/"
LOCK_FILE="$LOCK_FILE_PATH/$LOCK_FILE_NAME"
SSID_LOCK="StrangeSpot"

# Function to scan networks and output SSID and Security
scan_networks() {
    printf "rescan\n"
    iwlist wlp3s0 scan | awk -F: '
        /Cell/ { cell = $0 }
        /ESSID/ { ssid = $2 }
        /IE: WPA/ { security = "WPA" }
        /IE: IEEE 802.11i/ { security = "WPA2" }
        /IE: WPA3/ { security = "WPA3" }
        /Encryption key:on/ && !/IE: WPA/ && !/IE: IEEE 802.11i/ { security = "WEP" }
        /Encryption key:off/ { security = "Open" }
        /Quality/ {
            if (ssid && security) {
                gsub(/"/, "", ssid)
                print ssid " Security: " security
                ssid = ""; security = ""
            }
        }
    '
}

# Function to handle SSID selection
select_ssid() {
    while true; do
        networks=$(scan_networks)
        if [[ -z "$networks" ]]; then
            notify-send "Wi-Fi Connection" "No networks found\nRescanning ..."
            echo "No networks found, rescanning..."
            sleep 2
        elif [[ -n "$networks" ]]; then
            choice=$(echo "$networks" | dmenu -l 20 -p "Select SSID:")
            if [ -z "$choice" ]; then
                notify-send "Wi-Fi Connection" "No SSID selected or script exited."
                exit 1
            elif [[ -n "$choice" ]] && [[ "$choice" == "rescan" ]]; then
                echo "rescanning..."
                notify-send "Wi-Fi Connection" "Rescanning ..."
                sleep 2
                continue
            fi
            ssid=$(echo "$choice" | awk -F " Security: " '{print $1}')
            security=$(echo "$choice" | awk -F " Security: " '{print $2}')
            return 0 # Indicate successful SSID selection
        fi
    done
}

# Function to handle password prompt
prompt_password() {
    while true; do
        if [ "$security" != "Open" ]; then
            password=$(printf "rescan\nquit" | dmenu -p "Password for $ssid :")

            if [ "$password" = "quit" ]; then
                echo "Exiting..."
                exit 0
            elif [ "$password" = "rescan" ]; then
                return 1 # Indicate that rescan is requested
            elif [ -n "$password" ]; then
                break # Exit the password prompt loop with a valid password
            fi
        else
            break # Exit the password prompt loop if the network is open
        fi
    done
    return 0 # Indicate that password was provided
}

# Function to connect to the network
connect_network() {
    if [ "$security" = "Open" ]; then
        output=$(nmcli device wifi connect "$ssid" 2>&1)
    else
        if [ -z "$password" ]; then
            notify-send "Wi-Fi Connection" "No password provided for $ssid"
            return 1
        fi
        output=$(nmcli device wifi connect "$ssid" password "$password" 2>&1)
    fi

    # Check connection status
    if [ $? -eq 0 ]; then
        notify-send "Wi-Fi Connection" "Successfully connected to $ssid."
        return 0
    else
        notify-send "Wi-Fi Connection" "Failed to connect to $ssid. Output: $output"
        return 1
    fi
}

# Setup trap to remove lock on script exit
trap 'rm -f "$LOCK_FILE"' EXIT

# Main script execution
if [[ -e "$LOCK_FILE" ]];then 
    notify-send -u normal "Wi-Fi Connection" "Script Already running ..\n Lock File - '$LOCK_FILE' "
    exit 1;
else
    touch "$LOCK_FILE";
fi

if [ -n "$SSID_LOCK" ]; then
    dunstify "dmenu_wifi" "Running in SSID_LOCK mode\nSSID : $SSID_LOCK"
    counter=0;
    while true; do
        if [[ $counter -gt 2 ]];then
            nmcli device wifi list --rescan yes;
            counter=0;
        fi
        nmcli device wifi connect "$SSID_LOCK"
        if [ $? -eq 0 ];then
            dunstify "Wi-Fi Connection" "Successfully connected to $SSID_LOCK."
            break;
        fi
        ((counter++));
    done
    rm "$LOCK_FILE";
    exit 0;
fi

notify-send -u normal "Wi-Fi Connection" "Scanning SSID..."
while true; do
    select_ssid 
    while true; do
        # Prompt for password and check if rescan is requested
        if ! prompt_password; then
            break # Exit the password prompt loop to restart the SSID selection process
        fi

        connect_network
        # exit 0
    done
done

rm "$LOCK_FILE";
