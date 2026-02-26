import 'package:scrcpy_buddy/application/model/scrcpy/scrcpy_cli_argument.dart';
import 'package:scrcpy_buddy/main.dart';

@scrcpyArg
class GamepadMode extends ScrcpyCliArgument<String> {
  @override
  List<String> toArgs(String value) => [argument, value];

  @override
  final String argument = '--gamepad';

  @override
  final String label = 'control.gamepadMode';

  @override
  final List<String>? values = ['uhid', 'aoa', 'disabled'];
}
