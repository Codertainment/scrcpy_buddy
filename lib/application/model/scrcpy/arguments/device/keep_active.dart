import 'package:scrcpy_buddy/application/model/scrcpy/scrcpy_cli_argument.dart';
import 'package:scrcpy_buddy/main.dart';

@scrcpyArg
class KeepActive extends ScrcpyCliArgument<bool> {
  @override
  List<String> toArgs(bool value) => value ? [argument] : [];

  @override
  final String argument = '--keep-active';

  @override
  final String label = 'device.keepActive';

  @override
  final List<String>? values = null;
}
