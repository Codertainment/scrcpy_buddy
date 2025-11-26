// ignore_for_file: unused_import
import 'package:reflectable/reflectable.dart';

/// All of them must also be exported here in order to be registered with the reflectable package
export 'arguments/video/video_size.dart';
export 'arguments/video/video_bit_rate.dart';
export 'arguments/video/max_fps.dart';
export 'arguments/video/video_codec.dart';
export 'arguments/video/no_video.dart';
export 'arguments/control/no_control.dart';
export 'arguments/control/push_target.dart';
export 'arguments/control/keyboard_mode.dart';
export 'arguments/control/mouse_mode.dart';
export 'arguments/control/gamepad_mode.dart';

/// All {ScrcpyCliArgument}s must be annotated with this annotation.
class ScrcpyArg extends Reflectable {
  const ScrcpyArg(): super(newInstanceCapability, invokingCapability);
}
