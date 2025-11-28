import 'package:scrcpy_buddy/application/model/scrcpy/scrcpy_cli_argument.dart';
import 'package:scrcpy_buddy/main.dart';

@scrcpyArg
class AlwaysOnTop extends ScrcpyCliArgument<bool> {
  @override
  List<String> toArgs(bool value) => value ? [argument] : [];

  @override
  final String argument = '--always-on-top';

  @override
  final String label = 'window.alwaysOnTop';

  @override
  final List<String>? values = null;
}
