<p align="center">
    <a title="Made with Windows Design" href="https://github.com/bdlukaa/fluent_ui">
      <img
        src="https://img.shields.io/badge/fluent-design-blue?style=flat-square&color=gray&labelColor=0078D7"
      />
    </a>
    <a title="Dart" href="https://dart.dev/">
      <img
        src="https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white"
      />
    </a>
    <a title="Flutter" href="https://flutter.dev/">
      <img
        src="https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white"
      />
    </a>
    <a title="Latest supported scrcpy version" href="https://github.com/Genymobile/scrcpy/releases">
      <img
        src="https://img.shields.io/badge/scrcpy-v3.3.3-green?style=flat-square"
      />
    </a>
</p>

# scrcpy buddy 🤝

A simple, clean, minimalist GUI wrapper for [scrcpy](https://github.com/Genymobile/scrcpy).

## Requirements

To use this app, you need the following:

- adb setup and installed
- scrcpy installed (in the environment or in portable mode)
- Android device(s) with Developer options and USB / Network debugging enabled

# Technical documentation

## UI Framework

This project uses [fluent_ui](https://pub.dev/packages/fluent_ui) and tries to stick to available widgets and design
guidelines.

## Interacting with devices

Completely relies on ADB CLI.

- Listing devices
- Connection state
- Switching connection state (USB -> Network)
- Disconnect network device

## Supported scrcpy CLI Options

- Currently supported options are documented in [docs/scrcpy_options](docs/scrcpy_options)
- All options are categorised, and ideally are in their own navigation section
- Further, each option is marked as "Advanced" or not. Advanced options are to be hidden behind an Expander? (TBD)

### Docs -> Code mapping

- [`ScrcpyCliArgument`](lib/application/model/scrcpy/scrcpy_cli_argument.dart) is the base class for each option that's
  to be shown in the UI.
- Each option/arg should have it's own class which extends `ScrcpyCliArgument`
- Each option/arg class should be annotated with [`@scrcpyArg`](lib/application/model/scrcpy/scrcpy_arg.dart)
- Each class should also be exported in [`scrcpy_arg.dart`](lib/application/model/scrcpy/scrcpy_arg.dart) (Why? - see
  below)

### Synthetic reflection

- As we have multiple options and their classes, we need to be able to access their instances dynamically at runtime.
- Without reflection, this would need manual registration of each class in a central place, and thus making the
  management tedious.
- We solve this problem with the `reflactable` package. Our custom annotation `@scrcpyArg` marks all classes to be able
  to be reflected upon.
- They must be exported in the central [`scrcpy_arg.dart`](lib/application/model/scrcpy/scrcpy_arg.dart), so that they
  are not tree-shaken, and can be seen by `reflectable_builder` during `build_runner` stage.
