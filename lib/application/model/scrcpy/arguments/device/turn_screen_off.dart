import 'package:scrcpy_buddy/application/model/scrcpy/scrcpy_cli_argument.dart';
import 'package:scrcpy_buddy/main.dart';

@scrcpyArg
class TurnScreenOff extends ScrcpyCliArgument<bool> {
  @override
  List<String> toArgs(bool value) => value ? [argument] : [];

  @override
  final String argument = '--turn-screen-off';

  @override
  final String label = 'device.turnScreenOff';

  @override
  final List<String>? values = null;
}
