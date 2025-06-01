import 'package:fpdart/fpdart.dart';
import 'package:scrcpy_buddy/application/model/adb/adb_device.dart';
import 'package:scrcpy_buddy/application/model/adb/adb_error.dart';

class AdbResult {}

typedef AdbInitResult = Either<AdbError, int>;
typedef AdbDevicesResult = Either<AdbError, List<AdbDevice>>;
