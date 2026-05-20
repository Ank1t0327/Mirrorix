#!/usr/bin/env bash

CONFIG="$HOME/.mirrorix_setup_done"
if [ ! -f "$CONFIG" ]; then
    if [ -f "/usr/share/mirrorix/first_run.sh" ]; then
        if bash "/usr/share/mirrorix/first_run.sh"; then
            touch "$CONFIG"
        fi
    elif [ -f "/usr/local/share/mirrorix/first_run.sh" ]; then
        if bash "/usr/local/share/mirrorix/first_run.sh"; then
            touch "$CONFIG"
        fi
    elif [ -f "$HOME/mirrorix/setup/first_run.sh" ]; then
        if bash "$HOME/mirrorix/setup/first_run.sh"; then
            touch "$CONFIG"
        fi
    elif [ -f "$(dirname "$0")/setup/first_run.sh" ]; then
        if bash "$(dirname "$0")/setup/first_run.sh"; then
            touch "$CONFIG"
        fi
    fi
fi

TITLE="Mirrorix"
LOG_FILE="$HOME/.cache/mirrorix/mirrorix.log"
CONFIG_FILE="$HOME/.config/mirrorix/mirrorix.conf"

mkdir -p "$(dirname "$LOG_FILE")"
mkdir -p "$(dirname "$CONFIG_FILE")"

# Default config
SCRCPY_ARGS="--turn-screen-off --stay-awake"

# Load config if exists
if [ -f "$CONFIG_FILE" ]; then
    # shellcheck source=/dev/null
    source "$CONFIG_FILE"
else
    # Create default config
    echo "# Mirrorix Configuration" > "$CONFIG_FILE"
    echo "SCRCPY_ARGS=\"$SCRCPY_ARGS\"" >> "$CONFIG_FILE"
fi

# Redirect output for logging, but keep fd 3 and 4 for zenity interaction if needed
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>>"$LOG_FILE" 2>&1

echo "--- Starting Mirrorix at $(date) ---"

check_dependency() {
    if ! command -v "$1" &> /dev/null; then
        exec 1>&3 2>&4
        zenity --error --title="$TITLE" --text="$1 is not installed!"
        exit 1
    fi
}

check_dependency adb
check_dependency scrcpy
check_dependency nmap
check_dependency ip
check_dependency awk

IFACE=$(ip route | awk '/default/ {print $5}' | head -n 1)
if [ -z "$IFACE" ]; then
    exec 1>&3 2>&4
    zenity --error --title="$TITLE" --text="No active network connection found!"
    exit 1
fi

NETWORK=$(ip -o -f inet addr show "$IFACE" | awk '{print $4}' | head -n 1)

TMP_FILE=$(mktemp)
(
    # Get all IPs found
    IP_LIST=$(nmap -p 5555 --open -oG - "$NETWORK" | awk '/5555\/open/{print $2}')
    echo "$IP_LIST" > "$TMP_FILE"
) | zenity --progress --title="$TITLE" --text="Scanning network ($NETWORK) for Android devices..." --pulsate --auto-close --no-cancel

# If no file or empty
if [ ! -s "$TMP_FILE" ]; then
    exec 1>&3 2>&4
    zenity --error --title="$TITLE" --text="No Android device found on the network.\n\nConnect your phone once using USB and run:\n<b>adb tcpip 5555</b>\n\nCheck logs at: $LOG_FILE"
    rm -f "$TMP_FILE"
    exit 1
fi

mapfile -t IPS < "$TMP_FILE"
rm -f "$TMP_FILE"

# Filter out empty lines if any
IPS_FILTERED=()
for ip in "${IPS[@]}"; do
    if [ -n "$ip" ]; then
        IPS_FILTERED+=("$ip")
    fi
done

if [ "${#IPS_FILTERED[@]}" -eq 0 ]; then
    exec 1>&3 2>&4
    zenity --error --title="$TITLE" --text="No Android device found on the network.\n\nConnect your phone once using USB and run:\n<b>adb tcpip 5555</b>\n\nCheck logs at: $LOG_FILE"
    exit 1
elif [ "${#IPS_FILTERED[@]}" -eq 1 ]; then
    IP="${IPS_FILTERED[0]}"
else
    exec 1>&3 2>&4
    # Multiple IPs, present list
    ZENITY_ARGS=()
    for ip in "${IPS_FILTERED[@]}"; do
        ZENITY_ARGS+=("$ip")
    done
    IP=$(zenity --list --title="$TITLE" --text="Multiple devices found. Select one to mirror:" --column="IP" "${ZENITY_ARGS[@]}")
    exec 1>>"$LOG_FILE" 2>&1
    
    if [ -z "$IP" ]; then
        echo "User cancelled selection."
        exit 0
    fi
fi

(
    adb disconnect > /dev/null 2>&1
    adb connect "$IP:5555"
) | zenity --progress --title="$TITLE" --text="Connecting to $IP..." --pulsate --auto-close --no-cancel

# Check if successfully connected
if ! adb devices | grep -q "$IP:5555.*device"; then
    exec 1>&3 2>&4
    zenity --error --title="$TITLE" --text="Failed to connect to $IP:5555\n\nCheck logs at: $LOG_FILE"
    exit 1
fi

notify-send -a "$TITLE" -i /usr/share/icons/mirrorix.png "Device Connected" "Starting Screen Mirroring for $IP"

echo "Running scrcpy with args: $SCRCPY_ARGS"
# shellcheck disable=SC2086
scrcpy -s "$IP:5555" $SCRCPY_ARGS

adb disconnect "$IP:5555"
echo "--- Closed Mirrorix ---"
