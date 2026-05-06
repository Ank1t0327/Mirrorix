#!/usr/bin/env bash
CONFIG="$HOME/.mirrorix_setup_done"
if [ ! -f "$CONFIG" ]; then
    bash "$HOME/mirrorix/setup/first_run.sh"
    touch "$CONFIG"
fi
TITLE="Mirrorix"

check_dependency() {
    if ! command -v "$1" &> /dev/null; then
        zenity --error --text="$1 is not installed!"
        exit 1
    fi
}

check_dependency adb
check_dependency scrcpy
check_dependency nmap

zenity --info --title="$TITLE" --text="Scanning network for Android device..."

IFACE=$(ip route | awk '/default/ {print $5}')
NETWORK=$(ip -o -f inet addr show $IFACE | awk '{print $4}')

IP=$(nmap -p 5555 --open -oG - $NETWORK | awk '/5555\/open/{print $2; exit}')

if [ -z "$IP" ]; then
    zenity --error --text="No Android device found.

Connect phone once using USB and run:
adb tcpip 5555"
    exit 1
fi

adb disconnect > /dev/null 2>&1
adb connect $IP:5555

scrcpy -s $IP:5555 --turn-screen-off --stay-awake
