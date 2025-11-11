import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:scrcpy_buddy/application/model/scrcpy/scrcpy_error.dart';
import 'package:scrcpy_buddy/application/model/scrcpy/scrcpy_result.dart';

class RunningProcessManager {
  final Map<String, Process> _processMap = {};

  List<String> get keys => _processMap.keys.toList(growable: false);

  void add(String key, Process process) {
    _processMap[key] = process;
  }

  Process? get(String key) {
    return _processMap[key];
  }

  void remove(String key) {
    _processMap.remove(key);
  }

  ScrcpyStopResult stop(String key) {
    final process = _processMap[key];
    try {
      if (process != null) {
        if (process.kill()) {
          _processMap.remove(key);
          return ScrcpyStopResult.right(true);
        } else {
          return ScrcpyStopResult.left(ScrcpyKillError());
        }
      }
    } catch (e) {
      return ScrcpyStopResult.left(UnknownScrcpyError(exception: e));
    }
    return const Right(true);
  }
}
