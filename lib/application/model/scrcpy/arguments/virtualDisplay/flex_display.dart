import 'package:scrcpy_buddy/application/model/scrcpy/scrcpy_cli_argument.dart';
import 'package:scrcpy_buddy/main.dart';

@scrcpyArg
class FlexDisplay extends ScrcpyCliArgument<bool> {
  @override
  List<String> toArgs(bool value) => value ? [argument] : [];

  @override
  final String argument = '--flex-display';

  @override
  final String label = 'virtualDisplay.flex';

  @override
  final List<String>? values = null;
}
