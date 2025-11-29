import 'package:scrcpy_buddy/application/model/scrcpy/scrcpy_cli_argument.dart';
import 'package:scrcpy_buddy/main.dart';

@scrcpyArg
class NewDisplay extends ScrcpyCliArgument<String> {
  @override
  List<String> toArgs(String value) => ["$argument=$value"];

  @override
  final String argument = '--new-display';

  @override
  final String label = 'virtualDisplay.newDisplay';

  @override
  final List<String>? values = null;
}
