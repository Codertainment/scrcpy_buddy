import 'package:scrcpy_buddy/application/model/scrcpy/scrcpy_cli_argument.dart';
import 'package:scrcpy_buddy/main.dart';

@scrcpyArg
class VideoCodec extends ScrcpyCliArgument<String> {
  @override
  List<String> toArgs(String value) => [argument, value];

  @override
  final String argument = '--video-codec';

  @override
  final String label = 'video.codec';

  @override
  final List<String>? values = ['h264', 'h265', 'av1'];
}
