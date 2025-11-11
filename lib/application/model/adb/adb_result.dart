import 'package:fpdart/fpdart.dart';
import 'package:scrcpy_buddy/application/model/adb/adb_connect_result_status.dart';
import 'package:scrcpy_buddy/application/model/adb/adb_device.dart';
import 'package:scrcpy_buddy/application/model/adb/adb_error.dart';

typedef AdbInitResult = Either<AdbError, int>;
typedef AdbDevicesResult = Either<AdbError, List<AdbDevice>>;
typedef AdbConnectResult = Either<AdbError, AdbConnectResultStatus>;
typedef AdbDeviceIpResult = Either<AdbError, String>;