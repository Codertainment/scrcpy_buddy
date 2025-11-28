import 'package:scrcpy_buddy/application/model/scrcpy/scrcpy_cli_argument.dart';
import 'package:scrcpy_buddy/main.dart';

@scrcpyArg
class KeyboardMode extends ScrcpyCliArgument<String> {
  @override
  List<String> toArgs(String value) => [argument, value];

  @override
  final String argument = '--keyboard';

  @override
  final String label = 'control.keyboardMode';

  @override
  final List<String>? values = ['sdk', 'uhid', 'aoa', 'disabled'];
}