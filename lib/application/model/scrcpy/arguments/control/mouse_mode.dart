import 'package:scrcpy_buddy/application/model/scrcpy/scrcpy_cli_argument.dart';
import 'package:scrcpy_buddy/main.dart';

@scrcpyArg
class MouseMode extends ScrcpyCliArgument<String> {
  @override
  List<String> toArgs(String value) => [argument, value];

  @override
  final String argument = '--mouse';

  @override
  final String label = 'control.mouseMode';

  @override
  final List<String>? values = ['sdk', 'uhid', 'aoa', 'disabled'];
}
