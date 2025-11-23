import 'package:scrcpy_buddy/application/model/scrcpy/scrcpy_cli_argument.dart';
import 'package:scrcpy_buddy/main.dart';

@scrcpyArg
class VideoBitRate extends ScrcpyCliArgument<String> {
  @override
  List<String> toArgs(String value) => [argument, value];

  @override
  final String argument = '--video-bit-rate';

  @override
  final String label = 'video.bitRate';

  @override
  final List<String>? values = null;
}
