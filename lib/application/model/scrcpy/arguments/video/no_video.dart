import 'package:scrcpy_buddy/application/model/scrcpy/scrcpy_cli_argument.dart';
import 'package:scrcpy_buddy/main.dart';

@scrcpyArg
class NoVideo extends ScrcpyCliArgument<bool> {
  @override
  List<String> toArgs(bool value) => value ? [argument] : [];

  @override
  final String argument = '--no-video';

  @override
  final String label = 'video.noVideo';

  @override
  final List<String>? values = null;
}
