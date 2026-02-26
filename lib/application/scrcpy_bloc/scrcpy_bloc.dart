import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:scrcpy_buddy/application/app_settings.dart';
import 'package:scrcpy_buddy/application/model/scrcpy/scrcpy_error.dart';
import 'package:scrcpy_buddy/application/model/scrcpy/std_line.dart';
import 'package:scrcpy_buddy/either_utils.dart';
import 'package:scrcpy_buddy/service/running_process_manager.dart';
import 'package:scrcpy_buddy/service/scrcpy_service.dart';

part 'scrcpy_event.dart';
part 'scrcpy_state.dart';

typedef _Emitter = Emitter<ScrcpyState>;

class ScrcpyBloc extends Bloc<ScrcpyEvent, ScrcpyState> {
  ScrcpyBloc(this._processManager, this._service, this._settings) : super(ScrcpyInitial()) {
    on<StartScrcpyEvent>(_start, transformer: concurrent());
    on<StopScrcpyEvent>(_stop, transformer: concurrent());
  }

  final RunningProcessManager _processManager;
  final ScrcpyService _service;
  final AppSettings _settings;

  Set<String> get _runningDevices => _processManager.keys;

  Future<void> _start(StartScrcpyEvent event, _Emitter emit) async {
    final result = await _service.start(
      event.deviceSerial,
      _settings.adbExecutable.getValue(),
      _settings.scrcpyExecutable.getValue(),
      event.args,
    );
    result.mapLeft(
      (left) => emit(ScrcpyStartFailedState(deviceSerial: event.deviceSerial, error: left, devices: _runningDevices)),
    );
    if (result.isRight()) {
      // emit start success
      final startedAt = DateTime.now();
      final process = EitherUtils.getRight(result);
      _processManager.add(event.deviceSerial, process);
      emit(ScrcpyStartSuccessState(deviceSerial: event.deviceSerial, devices: _runningDevices));

      // wait for process to complete
      final exitCode = await process.exitCode;

      // check if process was stopped earlier (error path, because of a problem?)
      final stoppedAt = DateTime.now();
      final totalRuntimeDuration = stoppedAt.difference(startedAt);
      List<StdLine>? stdLines;
      Future? stdLinesFuture;
      if (totalRuntimeDuration.inSeconds < 10) {
        final stream = _processManager.getStdStream(event.deviceSerial);
        stdLinesFuture = stream?.last.then((lastValue) => stdLines = lastValue);
      }

      if (kDebugMode) {
        print('exit code for ${event.deviceSerial}: $exitCode');
        print('totalRuntimeDuration for ${event.deviceSerial}: $totalRuntimeDuration');
      }
      // clear from process manager
      _processManager.remove(event.deviceSerial);

      if (stdLinesFuture != null) {
        await stdLinesFuture;
        emit(
          ScrcpyStopSuccessState(
            deviceSerial: event.deviceSerial,
            devices: _runningDevices,
            totalRuntimeDuration: totalRuntimeDuration,
            stdLines: stdLines,
          ),
        );
      } else {
        emit(ScrcpyStopSuccessState(deviceSerial: event.deviceSerial, devices: _runningDevices));
      }
    }
  }

  void _stop(StopScrcpyEvent event, _Emitter emit) {
    final result = _processManager.stop(event.deviceSerial);
    result.mapLeft(
      (left) => emit(
        ScrcpyStopFailedState(
          deviceSerial: event.deviceSerial,
          error: ScrcpyStopError(left.exception),
          devices: _runningDevices,
        ),
      ),
    );
    result.map((_) => emit(ScrcpyStopSuccessState(deviceSerial: event.deviceSerial, devices: _runningDevices)));
  }
}
