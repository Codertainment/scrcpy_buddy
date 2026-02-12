import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:scrcpy_buddy/application/model/adb/adb_connect_result_status.dart';
import 'package:scrcpy_buddy/application/model/adb/adb_device.dart';
import 'package:scrcpy_buddy/application/model/adb/adb_error.dart';

typedef AdbTrackDevicesResult = Either<AdbError, Process>;
typedef AdbDevicesResult = Either<AdbError, List<AdbDevice>>;
typedef AdbConnectResult = Either<AdbError, AdbConnectResultStatus>;
typedef AdbVersionInfoResult = Either<AdbError, String>;
typedef AdbDeviceIpResult = Either<AdbError, String>;
