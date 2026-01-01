import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:process/process.dart';
import 'package:scrcpy_buddy/application/model/scrcpy/device_app.dart';
import 'package:scrcpy_buddy/application/model/scrcpy/scrcpy_error.dart';
import 'package:scrcpy_buddy/application/model/scrcpy/scrcpy_result.dart';

class ScrcpyService {
  final ProcessManager _processManager;

  ScrcpyService(this._processManager);

  Future<ScrcpyResult> start(String deviceSerial, String path, List<String> args) async {
    final execPath = path.isEmpty ? 'scrcpy' : path;
    try {
      return ScrcpyResult.right(await _processManager.start([execPath, '-s', deviceSerial, ...args]));
    } on ProcessException catch (e) {
      if (e.message.toLowerCase().contains("failed to find")) {
        return ScrcpyResult.left(ScrcpyNotFoundError());
      } else {
        return ScrcpyResult.left(UnknownScrcpyError(exception: e));
      }
    } catch (e) {
      return ScrcpyResult.left(UnknownScrcpyError(exception: e));
    }
  }

  Future<Either<ScrcpyError, String>> getVersionInfo(String? scrcpyPath) async {
    try {
      final result = await _processManager.run([scrcpyPath ?? 'scrcpy', '--version']);
      return Either.right(result.stdout.toString());
    } on ProcessException catch (e) {
      if (e.message.toLowerCase().contains("failed to find")) {
        return Either.left(ScrcpyNotFoundError());
      } else {
        return Either.left(UnknownScrcpyError(exception: e));
      }
    } catch (e) {
      return Either.left(UnknownScrcpyError(exception: e));
    }
  }

  Future<Either<ScrcpyError, List<DeviceApp>>> listApps(String deviceSerial, String path) async {
    final execPath = path.isEmpty ? 'scrcpy' : path;
    try {
      final processResult = await _processManager.run([execPath, '-s', deviceSerial, '--list-apps']);
      if (processResult.exitCode == 0) {
        final stdout = processResult.stdout.toString();
        final parts = stdout.split("List of apps:${Platform.lineTerminator}");

        // This regex handles both single and multi-line entries.
        // It looks for a starting character, captures the app name, and then the package name,
        // which might be on the next line.
        final regex = RegExp(r'^\s*([*-])\s+(.*?)\s+((?:[a-zA-Z0-9_]+\.)+[a-zA-Z0-9_]+)\s*$', multiLine: true);

        final matches = regex.allMatches(parts[1]);
        final apps = matches
            .map((match) => DeviceApp(isSystem: match.group(1) == "*", name: match.group(2)!, package: match.group(3)!))
            .toList(growable: false);
        return Either.right(apps);
      } else {
        return Either.left(ScrcpyListAppsError(processResult.stderr.toString()));
      }
    } on ProcessException catch (e) {
      if (e.message.toLowerCase().contains("failed to find")) {
        return Either.left(ScrcpyNotFoundError());
      } else {
        return Either.left(UnknownScrcpyError(exception: e));
      }
    } catch (e, stacktrace) {
      if (kDebugMode) {
        debugPrint(e.toString());
        debugPrintStack(stackTrace: stacktrace);
      }
      return Either.left(UnknownScrcpyError(exception: e));
    }
  }
}
