import 'dart:io';

import 'package:process/process.dart';
import 'package:scrcpy_buddy/application/model/scrcpy/scrcpy_error.dart';
import 'package:scrcpy_buddy/application/model/scrcpy/scrcpy_result.dart';

class ScrcpyService {
  final ProcessManager _processManager;

  ScrcpyService(this._processManager);

  Future<ScrcpyResult> start(String deviceSerial, List<String> args) async {
    try {
      return ScrcpyResult.right(
        await _processManager.start(['scrcpy', '-s', deviceSerial, ...args]),
      );
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
}
