import 'package:scrcpy_buddy/application/model/scrcpy/scrcpy_cli_argument.dart';
import 'package:scrcpy_buddy/main.dart';

@scrcpyArg
class AudioCodec extends ScrcpyCliArgument<String> {
  @override
  List<String> toArgs(String value) => [argument, value];

  @override
  final String argument = '--audio-codec';

  @override
  final String label = 'audio.codec';

  @override
  final List<String>? values = ['opus', 'aac', 'flac', 'raw'];
}
