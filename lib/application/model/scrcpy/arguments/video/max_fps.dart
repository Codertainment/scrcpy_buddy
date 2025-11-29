import 'package:scrcpy_buddy/application/model/scrcpy/scrcpy_cli_argument.dart';
import 'package:scrcpy_buddy/main.dart';

@scrcpyArg
class MaxFps extends ScrcpyCliArgument<String> {
  @override
  List<String> toArgs(String value) => [argument, value];

  @override
  final String argument = '--max-fps';

  @override
  final String label = 'video.maxFps';

  @override
  final List<String>? values = ['24', '30', '45', '60', '90', '120'];
}
