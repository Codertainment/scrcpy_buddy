import 'package:scrcpy_buddy/application/model/scrcpy/scrcpy_cli_argument.dart';
import 'package:scrcpy_buddy/main.dart';

@scrcpyArg
class CameraFacing extends ScrcpyCliArgument<String> {
  @override
  List<String> toArgs(String value) => [argument, value];

  @override
  final String argument = '--camera-facing';

  @override
  final String label = 'camera.facing';

  @override
  final List<String>? values = ['front', 'back', 'external'];
}
