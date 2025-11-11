// ignore_for_file: unused_import
import 'package:reflectable/reflectable.dart';

/// All of them must also be exported here in order to be registered with the reflectable package
export 'arguments/video/video_size.dart';

/// All {ScrcpyCliArgument}s must be annotated with this annotation.
class ScrcpyArg extends Reflectable {
  const ScrcpyArg(): super(newInstanceCapability, invokingCapability);
}
