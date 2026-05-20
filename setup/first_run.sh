#!/usr/bin/env bash

TITLE="Mirrorix Setup Wizard"

zenity --info \
    --title="$TITLE" \
    --width=400 \
    --text="<b>Welcome to Mirrorix!</b>\n\nSince this is your first time, we need to set up your Android device for wireless mirroring.\n\nThis will only take a minute. Click OK to begin."

zenity --info \
    --title="$TITLE - Step 1/4" \
    --width=400 \
    --text="<b>Enable Developer Options</b>\n\n1. Open <b>Settings</b> on your phone.\n2. Go to <b>About phone</b>.\n3. Scroll down and tap <b>Build number</b> 7 times quickly until it says 'You are now a developer!'.\n\nClick OK when done."

zenity --info \
    --title="$TITLE - Step 2/4" \
    --width=400 \
    --text="<b>Enable USB Debugging</b>\n\n1. Go back to main <b>Settings</b>.\n2. Go to <b>System</b> > <b>Developer options</b> (or search for it).\n3. Find <b>USB debugging</b> and toggle it ON.\n\nClick OK when done."

zenity --info \
    --title="$TITLE - Step 3/4" \
    --width=400 \
    --text="<b>Connect via USB</b>\n\nPlease connect your phone to this computer using a USB cable right now.\n\n<i>Note: Your phone might ask to 'Allow USB debugging'. Check the box 'Always allow from this computer' and tap Allow.</i>\n\nClick OK after plugging it in."

# Wait for device loop
while true; do
    DEVICE_STATE=$(adb devices | grep -w "device\|unauthorized" | awk '{print $2}' | head -n 1)

    if [ -z "$DEVICE_STATE" ]; then
        if ! zenity --question --title="$TITLE" --text="No device detected.\n\nMake sure the USB cable is connected securely and USB debugging is ON.\n\nTry again?" --ok-label="Retry" --cancel-label="Cancel"; then
            exit 1
        fi
    elif [ "$DEVICE_STATE" = "unauthorized" ]; then
        zenity --warning --title="$TITLE" --text="<b>Action Required on Phone!</b>\n\nPlease look at your phone's screen and tap <b>Allow</b> for USB debugging.\n\nClick OK here after you've allowed it."
    elif [ "$DEVICE_STATE" = "device" ]; then
        # Device connected and authorized!
        break
    fi
    sleep 1
done

# Enable TCP/IP
(
    echo "10" ; echo "# Restarting ADB in TCP/IP mode..." ; sleep 1
    adb tcpip 5555 > /dev/null 2>&1
    echo "90" ; echo "# Configuring wireless connection..." ; sleep 1
) | zenity --progress --title="$TITLE - Step 4/4" --text="Enabling Wireless Mode..." --auto-close --pulsate --no-cancel

# Verify success
if adb devices | grep -q "device"; then
    zenity --info \
        --title="$TITLE - Complete!" \
        --width=400 \
        --text="<b>Setup Complete! 🎉</b>\n\nYour phone is now configured for wireless mirroring.\n\n<b>Important: You can now disconnect the USB cable!</b>\n\nMirrorix will now attempt to find and connect to your phone over Wi-Fi."
else
    zenity --error \
        --title="$TITLE" \
        --text="Something went wrong while enabling wireless mode. Please try running the setup again."
    exit 1
fi
