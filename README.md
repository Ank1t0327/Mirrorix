# Mirrorix

Wireless Android screen mirroring for Linux using scrcpy + ADB.

## Features

- One-click Android mirroring
- Automatic network scanning
- Wireless ADB connection
- Desktop launcher support
- Beginner-friendly setup wizard
- Lightweight and fast
- Multi-device support with selection menu
- Custom configuration file for scrcpy arguments
- Comprehensive background logging

## Requirements

- Linux
- Android device
- USB Debugging enabled

## Installation

The easiest way to install Mirrorix is via our official APT repository!

```bash
# Add the Mirrorix APT repository
echo "deb [trusted=yes] https://Ank1t0327.github.io/Mirrorix/apt/ ./" | sudo tee /etc/apt/sources.list.d/mirrorix.list

# Update your package list and install
sudo apt update
sudo apt install mirrorix
```

> **Note:** Mirrorix will display first-time setup instructions after installation. Be sure to run it with your device connected via USB the first time.

### Manual Installation (From Source)

```bash
git clone https://github.com/Ank1t0327/Mirrorix.git
cd mirrorix
chmod +x install.sh
sudo ./install.sh
```

## Usage

Launch from:
- Applications menu
OR
- terminal:

```bash
mirrorix
```

## Configuration

You can customize `scrcpy` parameters by editing the configuration file located at `~/.config/mirrorix/mirrorix.conf`.

Example `mirrorix.conf`:
```bash
# Mirrorix Configuration
SCRCPY_ARGS="--turn-screen-off --stay-awake --max-fps 60 --video-bit-rate 8M"
```

## Logging

Logs are saved to `~/.cache/mirrorix/mirrorix.log`. Check here if you encounter connection issues.

## Uninstallation

If installed via APT, run:
```bash
sudo apt remove mirrorix
```

If installed manually from source, run:
```bash
./uninstall.sh
```

## Technologies Used

- scrcpy
- adb
- nmap
- zenity

## License

MIT
