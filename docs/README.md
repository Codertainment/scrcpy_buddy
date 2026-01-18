# Technical documentation

<!-- TOC -->
* [Technical documentation](#technical-documentation)
  * [Getting started with development](#getting-started-with-development)
  * [UI Framework](#ui-framework)
  * [Interacting with devices](#interacting-with-devices)
  * [Supported scrcpy CLI Options](#supported-scrcpy-cli-options)
    * [Docs -> Code mapping](#docs---code-mapping)
    * [Synthetic reflection](#synthetic-reflection)
<!-- TOC -->

## Getting started with development

- Clone the project locally
- Get flutter dependencies: `flutter pub get`
- Run build_runner: `dart run build_runner build`
- Run the app for your OS: `flutter run -d <linux|windows|macos>`

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

- Currently supported options are documented in [scrcpy_options](scrcpy_options)
- All options are categorised, and ideally are in their own navigation section
- Further, each option is marked as "Advanced" or not. Advanced options are to be hidden behind an Expander? (TBD)

### Docs -> Code mapping

- [`ScrcpyCliArgument`](/lib/application/model/scrcpy/scrcpy_cli_argument.dart) is the base class for each option that's
  to be shown in the UI.
- Each option/arg should have it's own class which extends `ScrcpyCliArgument`
- Each option/arg class should be annotated with [`@scrcpyArg`](/lib/application/model/scrcpy/scrcpy_arg.dart)
- Each class should also be exported in [`scrcpy_arg.dart`](/lib/application/model/scrcpy/scrcpy_arg.dart) (Why? - see
  below)

### Synthetic reflection

- As we have multiple options and their classes, we need to be able to access their instances dynamically at runtime.
- Without reflection, this would need manual registration of each class in a central place, and thus making the
  management tedious.
- We solve this problem with the `reflactable` package. Our custom annotation `@scrcpyArg` marks all classes to be able
  to be reflected upon.
- They must be exported in the central [`scrcpy_arg.dart`](/lib/application/model/scrcpy/scrcpy_arg.dart), so that they
  are not tree-shaken, and can be seen by `reflectable_builder` during `build_runner` stage.
