import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:scrcpy_buddy/application/model/adb/adb_device.dart';
import 'package:scrcpy_buddy/application/model/adb/adb_result.dart';

import 'model/adb/adb_connect_result_status.dart';
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
    try {
      final result = await process;
      final lines = result.stdout.toString().split("\n")
        ..removeAt(0)
        ..removeWhere((line) => line.trim().isEmpty);

      final devices = lines.map((line) => _parseDevice(line)).toList(growable: false);

      return AdbDevicesResult.right(devices);
    } catch (e) {
      return AdbDevicesResult.left(UnknownAdbError(exception: e));
    }
  }

  AdbDevice _parseDevice(String line) {
    final parts = line.split(RegExp(r"\s+")).filter((part) => part.isNotEmpty).toList(growable: false);
    return AdbDevice(
      serial: parts[0],
      status: AdbDeviceStatus.values.byName(parts[1]),
      metadata: parseMetadata(parts.sublist(2)),
    );
  }

  Map<String, String> parseMetadata(List<String> metadata) {
    return metadata.fold(<String, String>{}, (acc, part) {
      final parts = part.split(":");
      if (parts.length >= 2) {
        acc[parts[0]] = parts[1];
      }
      return acc;
    });
  }

  Future<AdbConnectResult> parseConnectResult(Future<ProcessResult> process) async {
    try {
      final result = await process;
      if (result.exitCode == 0) {
        return AdbConnectResult.right(AdbConnectResultStatus.success);
      } else if (result.stdout.toString().contains("failed to authenticate")) {
        return AdbConnectResult.right(AdbConnectResultStatus.pendingAuthorization);
      } else {
        return AdbConnectResult.left(AdbConnectError(result.stderr.toString()));
      }
    } catch (e) {
      return AdbConnectResult.left(UnknownAdbError(exception: e));
    }
  }
}
