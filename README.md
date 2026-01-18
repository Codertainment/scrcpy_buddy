<p align="center">
    <a title="Made with Windows Design" href="https://github.com/bdlukaa/fluent_ui"><img alt="Made with Windows Design" src="https://img.shields.io/badge/fluent-design-blue?style=flat-square&color=gray&labelColor=0078D7"
      /></a>
    <a title="Dart" href="https://dart.dev/"><img alt="Dart" src="https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white"
      /></a>
    <a title="Flutter" href="https://flutter.dev/"><img src="https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white"
       alt="Flutter"/></a>
    <a title="Latest supported scrcpy version" href="https://github.com/Genymobile/scrcpy/releases"><img src="https://img.shields.io/badge/scrcpy-v3.3.4-green?style=flat-square"
       alt="scrcpy v3.3.4"/></a>
</p>

# scrcpy buddy 🤝

![](/media/banner.png "banner")

scrcpy buddy is a clean, minimalist Flutter-based desktop application that provides an intuitive graphical interface
for [scrcpy](https://github.com/Genymobile/scrcpy), the popular Android screen mirroring and control tool. Built with
Fluent UI design principles, it brings a polished, native desktop experience to managing your Android devices across
Windows, Linux, and macOS.

<!-- TOC -->

* [scrcpy buddy 🤝](#scrcpy-buddy-)
    * [Requirements](#requirements)
    * [Features](#features)
        * [Coming next](#coming-next)
    * [Screenshots](#screenshots)
    * [Download & Installation](#download--installation)
        * [Supported and tested platforms](#supported-and-tested-platforms)
        * [Installation](#installation)
            * [MacOS](#macos)
            * [Opening the app on MacOS](#opening-the-app-on-macos)
            * [Linux](#linux)
            * [Windows](#windows)
    * [Usage instructions](#usage-instructions)
        * [Running scrcpy](#running-scrcpy)
        * [Customizing scrcpy options](#customizing-scrcpy-options)
        * [Profile management](#profile-management)
        * [Configuring a default profile](#configuring-a-default-profile)
    * [Troubleshooting](#troubleshooting)
        * [ADB / scrcpy not found](#adb--scrcpy-not-found)
        * [Setting executable path manually in settings](#setting-executable-path-manually-in-settings)
    * [License](#license)
    * [How it works](#how-it-works)
        * [List of commands used by the app](#list-of-commands-used-by-the-app)
            * [ADB Commands](#adb-commands)
            * [scrcpy Commands](#scrcpy-commands)

<!-- TOC -->

## Requirements

To use this app, you need the following:

- [adb](https://developer.android.com/tools/adb) (in `$PATH` or in portable mode)
- [scrcpy](https://github.com/Genymobile/scrcpy) (in `$PATH` or in portable mode)
- Android device(s) with "Developer options" and USB / Network debugging
  enabled: https://developer.android.com/tools/adb#Enabling

## Features

- Run scrcpy on multiple connected devices
- ADB Device management (Switch USB Device to network / disconnect device)
- Profile management (name, customized scrcpy options, default profile)
- Light / Dark theme support
- View console output for devices which are running scrcpy
- Convenient app selection
  for [starting an app with scrcpy](https://github.com/Genymobile/scrcpy/blob/master/doc/device.md#start-android-app)
  from a connected device
- Close app to tray

### Coming next

See [milestones](https://github.com/Codertainment/scrcpy_buddy/milestones)

## Screenshots

(may not be up-to-date)

| Screenshots                                                                   | Screenshots                                                                   | Screenshots                                                       |
|-------------------------------------------------------------------------------|-------------------------------------------------------------------------------|-------------------------------------------------------------------|
| ![](/media/screenshots/windows/devices_console.png "devices and console out") | ![](/media/screenshots/windows/audio.png "audio options")                     | ![](/media/screenshots/windows/camera.png "camera options")       |
| ![](/media/screenshots/windows/control.png "device options")                  | ![](/media/screenshots/windows/device.png "device options")                   | ![](/media/screenshots/windows/recording.png "recording options") |
| ![](/media/screenshots/windows/video.png "video options")                     | ![](/media/screenshots/windows/virtual_display.png "virtual display options") | ![](/media/screenshots/windows/window.png "window options")       |
| ![](/media/screenshots/windows/profile_dropdown.png "profile dropdown")       | ![](/media/screenshots/windows/profile_management.png "profile management")   | ![](/media/screenshots/macos/settings.png "app settings")         |

## Download & Installation

All downloads can be found on the [latest release](https://github.com/Codertainment/scrcpy_buddy/releases/latest) page

### Supported and tested platforms

| OS      | Minimum Supported           | Tested ✅      |
|---------|-----------------------------|---------------|
| MacOS   | 11 Big Sur                  | 26 Tahoe      |
| Windows | 7 (?)                       | 11            |
| Linux   | Should work on all versions | KUbuntu 25.10 |

### Installation

#### MacOS

- Download and open the DMG File
- Make sure you have administrator privileges
- Drag and drop the app icon to "Applications" folder
- Open the app by searching for it (<kbd>⌘</kbd> <kbd>Space</kbd>)
- See [the next section](#opening-the-app-on-macos) to understand how to open the app

#### Opening the app on MacOS

For macOS apps to be verified, a developer account is required, which has a membership fee of $99/year. As this is my
personal project, I cannot afford this.

Hence, the app is unverified, and it requires **manual intervention to open it for the first time**.

Follow the instructions from [Apple Support](https://support.apple.com/guide/mac-help/mchleab3a043) to manually override
the signing and check and open the app.

#### Linux

Possible installation options:

- Install from Snap Store (coming soon)
- Download and install the snap manually (`$ sudo snap install <file_name>.snap --classic --dangerous`)
- Download and open the AppImage

#### Windows

<p>
    <a href="https://apps.microsoft.com/detail/9pk010v7h9fs?referrer=appbadge&cid=github-readme&mode=direct">
    	<img src="https://get.microsoft.com/images/en-us%20dark.svg" width="200" alt="Download from the Microsoft Store"/>
    </a>
</p>

Possible installation options:

- Install directly from [Microsoft Store](https://apps.microsoft.com/detail/9pk010v7h9fs) (Recommended for automatic
  updates)
- Install via EXE Setup

## Usage instructions

### Running scrcpy

Once you have everything setup, connected Android devices (through ADB) should show up in the homepage (known as "
Devices").

The app also shows the device status and the serial number.

To run scrcpy on your device(s):

- Select available device(s)
- Configure scrcpy options as you wish by navigating to the categories
- Click on "Start" at the top right corner

### Customizing scrcpy options

- Simply navigate to the desired category from the navigation drawer
- Change the options as you'd like
- All changes are saved automatically to the currently selected profile (visible in the dropdown button at top right)

### Profile management

A profile contains:

1. Name
2. Customized scrcpy options

You can create, rename and delete profiles from the "Manage profiles" page.

The dropdown button at the top indicates the currently active profile.

By clicking on the dropdown button, you can switch between profiles, create a new profile or navigate to the profile
management page.

### Configuring a default profile

You can choose a single profile to be the default one (everytime you open the app), or let the last used profile be the
default one.

To configure a specific profile as the default one, either:

- Go to the profile management page, and set it as default by clicking the overflow menu button (...)
- Go to settings, under the "Default profile" section, select a profile

To default to the last used profile:

- Go to settings, under the "Default profile" section, select "Last used" from the dropdown menu

## Troubleshooting

### ADB / scrcpy not found

If you have ADB and/or scrcpy setup and installed in your path:

- Depending on the platform, the app may not be able to find ADB / scrcpy in the path. You
  can [set the executable in settings manually](#setting-executable-path-manually-in-settings).
- To find out the installation path, run this command in the terminal:
- e.g.
    - For Windows: `where adb`
    - For MacOS/Linux: `which adb`

### Setting executable path manually in settings

![](/media/screenshots/macos/settings.png "app settings")

For adb and/or scrcpy: paste the full executable path in the textbox. (e.g. `/opt/homebrew/bin/adb`)

Verify that the app is able to access the executables by clicking on "Check".

It should show the adb or scrcpy version.

## How it works

scrcpy buddy functions as a graphical user interface (GUI) wrapper for command-line tools. The application does not
communicate directly with Android devices or access device data itself. Instead, it exclusively interacts with adb and
scrcpy.
All device communication and data processing occur through these external tools, which operate under their own
respective privacy policies and security models.

### List of commands used by the app

#### ADB Commands

- `adb --version` - Retrieves the installed adb version
- `adb devices -l` - Lists connected Android devices
- `adb start-server` - Starts the ADB server process
- `adb connect` - Connects to Android devices over network
- `adb disconnect` - Disconnects from network-connected devices
- `adb shell ip route show` - Retrieves network routing information from connected devices
- `adb tcpip` - Switches device connection mode to TCP/IP

#### scrcpy Commands

- `scrcpy` - Launches screen mirroring with user-configured options from the application UI
- `scrcpy --version` - Retrieves the installed scrcpy version
- `scrcpy --list-apps` - Lists applications installed on connected devices

## License

Apache-2.0: See [LICENSE](LICENSE)

## Artworks credits

> The Android robot is reproduced or modified from work created and shared by Google and used according to terms
> described in the Creative Commons 3.0 Attribution License (https://creativecommons.org/licenses/by/3.0/).

Thanks to my friend, @SudipRajbanshi for creating the beautiful logo, banner and tray icon ❤️