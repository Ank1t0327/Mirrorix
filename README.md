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
echo "deb [trusted=yes] https://Ank1t0327.github.io/Mirrorix/ stable main" | sudo tee /etc/apt/sources.list.d/mirrorix.list

# Update your package list and install
sudo apt update
sudo apt install mirrorix
```

> **Note:** You must enable GitHub Pages from the Settings > Pages menu of your repository, and set the source branch to `gh-pages` for this to work.

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

To remove Mirrorix from your system, run:
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
