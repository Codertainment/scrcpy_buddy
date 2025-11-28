import 'package:scrcpy_buddy/application/model/scrcpy/scrcpy_cli_argument.dart';
import 'package:scrcpy_buddy/main.dart';

@scrcpyArg
class WindowTitle extends ScrcpyCliArgument<String> {
  @override
  List<String> toArgs(String value) => [argument, value];

  @override
  final String argument = '--window-title';

  @override
  final String label = 'window.title';

  @override
  final List<String>? values = null;
}
