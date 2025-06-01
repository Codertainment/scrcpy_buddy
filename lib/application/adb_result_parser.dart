import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:scrcpy_buddy/application/model/adb/adb_device.dart';
import 'package:scrcpy_buddy/application/model/adb/adb_result.dart';

import 'model/adb/adb_error.dart';

class AdbResultParser {
  Future<AdbInitResult> parseInitResult(Future<ProcessResult> process) async {
    try {
      final result = await process;
      if (kDebugMode) {
        print("ADB init result: ${result.exitCode}\nStdOut: ${result.stdout}\nStdErr: ${result.stderr}");
      }
      return AdbInitResult.right(result.exitCode);
    } on ProcessException catch (e) {
      if (e.message.toLowerCase().contains("failed to find")) {
        return AdbInitResult.left(AdbNotFoundError());
      } else {
        return AdbInitResult.left(UnknownAdbError(exception: e));
      }
    } catch (e) {
      return AdbInitResult.left(UnknownAdbError(exception: e));
    }
  }

  Future<AdbDevicesResult> parseDevicesResult(Future<ProcessResult> process) async {
    final result = await process;
    final lines = result.stdout.toString().split("\n")
      ..removeAt(0)
      ..removeWhere((line) => line.trim().isEmpty);

    final devices = lines.map((line) => _parseDevice(line)).toList(growable: false);

    return AdbDevicesResult.right(devices);
  }

  AdbDevice _parseDevice(String line) {
    print(line);
    final parts = line.split(r"\\s+");

    return AdbDevice(serial: parts[0], status: AdbDeviceStatus.values.byName(parts[1]), metadata: parts.sublist(2));
  }
}
