#!/usr/bin/env bash

zenity --info \
--title="Mirrorix Setup" \
--text="Welcome to Mirrorix!\n\nStep 1:\nEnable USB Debugging on your Android phone."

zenity --info \
--title="Mirrorix Setup" \
--text="Step 2:\nConnect your Android phone using USB."

adb devices

adb tcpip 5555

zenity --info \
--title="Mirrorix Setup" \
--text="Wireless ADB enabled!\n\nYou may now disconnect USB and use Mirrorix wirelessly."
