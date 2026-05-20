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

```bash
git clone https://github.com/YOURNAME/mirrorix.git
cd mirrorix
chmod +x install.sh
./install.sh
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
