import 'package:scrcpy_buddy/application/model/scrcpy/scrcpy_cli_argument.dart';
import 'package:scrcpy_buddy/main.dart';

@scrcpyArg
class V4l2Sink extends ScrcpyCliArgument<String> {
  @override
  List<String> toArgs(String value) => [argument, value];

  @override
  final String argument = '--v4l2-sink';

  @override
  final String label = 'v4l2.sink';

  @override
  final List<String>? values = null;
}
