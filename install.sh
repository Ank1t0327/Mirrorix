#!/usr/bin/env bash

echo "[*] Installing dependencies..."

sudo apt update
sudo apt install scrcpy adb nmap zenity -y

echo "[*] Installing Mirrorix..."

sudo cp mirrorix.sh /usr/local/bin/mirrorix
sudo chmod +x /usr/local/bin/mirrorix

sudo cp mirrorix.desktop /usr/share/applications/

sudo cp icons/mirror.png /usr/share/icons/mirrorix.png

sudo mkdir -p /usr/local/share/mirrorix
sudo cp setup/first_run.sh /usr/local/share/mirrorix/first_run.sh
sudo chmod +x /usr/local/share/mirrorix/first_run.sh

echo "[+] Installation complete!"
