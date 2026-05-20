#!/usr/bin/env bash

echo "[*] Uninstalling Mirrorix..."

sudo rm -f /usr/local/bin/mirrorix
sudo rm -f /usr/share/applications/mirrorix.desktop
sudo rm -f /usr/share/icons/mirrorix.png
sudo rm -rf /usr/local/share/mirrorix

echo "[+] Uninstallation complete!"
