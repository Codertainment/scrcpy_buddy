import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scrcpy_buddy/application/model/scrcpy/scrcpy_error.dart';
import 'package:scrcpy_buddy/application/model/scrcpy/scrcpy_result.dart';
import 'package:scrcpy_buddy/application/model/scrcpy/std_line.dart';

class RunningProcessManager {
  final Map<String, Process> _processMap = {};
  final Map<String, BehaviorSubject<List<StdLine>>> _stdBehaviorSubjects = {};

  Set<String> get keys => _processMap.keys.toSet();

  void add(String key, Process process) {
    _processMap[key] = process;
    final behaviorSubject = BehaviorSubject<List<StdLine>>();
    final outSubscription = process.stdout.map((out) {
      final outString = utf8.decode(out);
      if (kDebugMode) {
        debugPrint("out $key: $outString");
      }
      return StdLine(line: outString);
    });
    final errSubscription = process.stderr.map((err) {
      final errString = utf8.decode(err);
      if (kDebugMode) {
        debugPrint("err $key: $errString");
      }
      return StdLine(isError: true, line: errString);
    });
    final merged = Rx.merge([outSubscription, errSubscription]);

    final finalMerged = merged.scan<List<StdLine>>((accumulated, current, _) {
      accumulated.add(current);
      return accumulated;
    }, <StdLine>[]);
    behaviorSubject.addStream(finalMerged);

    _stdBehaviorSubjects[key] = behaviorSubject;
  }

  Stream<List<StdLine>>? getStdStream(String key) => _stdBehaviorSubjects[key]?.asBroadcastStream();

  Process? get(String key) {
    return _processMap[key];
  }

  void remove(String key) {
    _processMap.remove(key);
    _stdBehaviorSubjects[key]?.close();
    _stdBehaviorSubjects.remove(key);
  }

  ScrcpyStopResult stop(String key) {
    final process = _processMap[key];
    try {
      if (process != null) {
        if (process.kill()) {
          remove(key);
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
