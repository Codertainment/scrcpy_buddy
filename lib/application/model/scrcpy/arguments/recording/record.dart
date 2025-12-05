import 'package:scrcpy_buddy/application/model/scrcpy/scrcpy_cli_argument.dart';
import 'package:scrcpy_buddy/main.dart';

@scrcpyArg
class Record extends ScrcpyCliArgument<String> {
  @override
  List<String> toArgs(String value) => [argument, value];

  @override
  final String argument = '--record';

  @override
  final String label = 'recording.record';

  @override
  final List<String>? values = null;
}
