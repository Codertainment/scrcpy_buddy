import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:scrcpy_buddy/application/app_settings.dart';
import 'package:scrcpy_buddy/application/model/scrcpy/scrcpy_error.dart';
import 'package:scrcpy_buddy/either_utils.dart';
import 'package:scrcpy_buddy/service/running_process_manager.dart';
import 'package:scrcpy_buddy/service/scrcpy_service.dart';

part 'scrcpy_event.dart';
part 'scrcpy_state.dart';

typedef _Emitter = Emitter<ScrcpyState>;

class ScrcpyBloc extends Bloc<ScrcpyEvent, ScrcpyState> {
  ScrcpyBloc(this._processManager, this._service, this._settings) : super(ScrcpyInitial()) {
    on<StartScrcpyEvent>(_start, transformer: concurrent());
    on<StopScrcpyEvent>(_stop);
  }

  final RunningProcessManager _processManager;
  final ScrcpyService _service;
  final AppSettings _settings;

  List<String> get _runningDevices => _processManager.keys;

  Future<void> _start(StartScrcpyEvent event, _Emitter emit) async {
    final result = await _service.start(event.deviceSerial, _settings.scrcpyExecutable.getValue(), event.args);
    result.mapLeft(
      (left) => emit(ScrcpyStartFailedState(deviceSerial: event.deviceSerial, error: left, devices: _runningDevices)),
    );
    if (result.isRight()) {
      final process = EitherUtils.getRight(result);
      _processManager.add(event.deviceSerial, process);
      emit(ScrcpyStartSuccessState(deviceSerial: event.deviceSerial, devices: _runningDevices));
      await process.exitCode;
      _processManager.remove(event.deviceSerial);
      emit(ScrcpyStopSuccessState(deviceSerial: event.deviceSerial, devices: _runningDevices));
    }
  }

  void _stop(StopScrcpyEvent event, _Emitter emit) {
    final result = _processManager.stop(event.deviceSerial);
    result.mapLeft(
      (left) => emit(ScrcpyStopFailedState(deviceSerial: event.deviceSerial, error: left, devices: _runningDevices)),
    );
    result.map((_) => emit(ScrcpyStopSuccessState(deviceSerial: event.deviceSerial, devices: _runningDevices)));
  }
}
