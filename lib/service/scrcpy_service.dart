import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:process/process.dart';
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
}
