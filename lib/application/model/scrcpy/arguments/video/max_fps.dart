import 'package:scrcpy_buddy/application/model/scrcpy/scrcpy_cli_argument.dart';
import 'package:scrcpy_buddy/main.dart';

@scrcpyArg
class MaxFps extends ScrcpyCliArgument<int> {
  @override
  List<String> toArgs(int value) => [argument, value.toString()];

  @override
  final String argument = '--max-fps';

  @override
  final String label = 'video.maxFps';

  @override
  final List<String>? values = null;
}
