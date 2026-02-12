import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:scrcpy_buddy/application/model/adb/adb_device.dart';
import 'package:scrcpy_buddy/application/model/adb/adb_error.dart';
import 'package:scrcpy_buddy/service/adb_service.dart';
import 'package:scrcpy_buddy/service/running_process_manager.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

part 'devices_event.dart';
part 'devices_state.dart';

typedef _Emitter = Emitter<DevicesState>;

class DevicesBloc extends Bloc<DevicesEvent, DevicesState> {
  DevicesBloc(this._runningProcessManager, this._adbService, this._adbPath) : super(const DevicesInitial()) {
    on<InitDeviceTracking>((_, emit) => _startTracking(emit));
    on<RestartTracking>(_restartTracking);
    on<LoadDevices>(_onLoadDevices);
    on<ToggleDeviceSelection>(_onToggleDeviceSelection);
  }

  bool _isTracking = false;
  final AdbService _adbService;
  final RunningProcessManager _runningProcessManager;
  final List<AdbDevice> _devices = [];
  final Set<String> _selectedDeviceSerials = {};
  final Preference<String> _adbPath;

  static const String adbTrackDevicesKey = "adb-track-devices";

  @override
  Future<void> close() {
    _stopTracking();
    return super.close();
  }

  void _stopTracking() {
    _runningProcessManager
        .stop(adbTrackDevicesKey)
        .mapLeft((error) => debugPrint(error.exception?.toString() ?? 'Unknown stop error'))
        .map((stopped) => kDebugMode ? debugPrint("Stopped: $stopped") : null);

    _isTracking = false;
  }

  Future<void> _restartTracking(RestartTracking _, _Emitter emit) async {
    if (_isTracking) _stopTracking();
    await _startTracking(emit);
  }

  Future<void> _startTracking(_Emitter emit) async {
    if (_isTracking) {
      emit(InitDeviceTrackingSuccess());
      return;
    }
    final trackDevicesResult = await _adbService.startTrackDevices(_adbPath.getValue());
    trackDevicesResult.fold((error) => emit(InitDeviceTrackingFailed(adbError: error, message: error.toString())), (
      process,
    ) {
      _isTracking = true;
      _runningProcessManager.add(adbTrackDevicesKey, process);
      emit(InitDeviceTrackingSuccess());
    });
  }

  Future<void> _onLoadDevices(_, _Emitter emit) async {
    try {
      emit(DevicesLoading());
      final devicesResult = await _adbService.devices(_adbPath.getValue());
      devicesResult.fold(
        (error) => emit(
          DevicesUpdateError(
            devices: _devices,
            selectedDeviceSerials: _selectedDeviceSerials,
            adbError: error,
            message: error.toString(),
          ),
        ),
        (devices) {
          _devices.clear();
          _devices.addAll(devices);
          final currentSerials = devices
              .where((device) => device.status == AdbDeviceStatus.device)
              .map((d) => d.serial)
              .toSet();
          final newSelectedDeviceSerials = _selectedDeviceSerials.intersection(currentSerials);
          _selectedDeviceSerials.clear();
          _selectedDeviceSerials.addAll(newSelectedDeviceSerials);
          _emitSuccess(emit);
        },
      );
    } on ProcessException catch (_) {
      emit(
        DevicesUpdateError(
          devices: _devices,
          selectedDeviceSerials: _selectedDeviceSerials,
          adbError: AdbNotFoundError(),
        ),
      );
    } catch (e) {
      print(e);
      emit(DevicesUpdateError(devices: _devices, selectedDeviceSerials: _selectedDeviceSerials, message: e.toString()));
    }
  }

  void _onToggleDeviceSelection(ToggleDeviceSelection event, _Emitter emit) {
    if (_selectedDeviceSerials.contains(event.deviceSerial)) {
      _selectedDeviceSerials.remove(event.deviceSerial);
    } else {
      _selectedDeviceSerials.add(event.deviceSerial);
    }
    _emitSuccess(emit);
  }

  void _emitSuccess(_Emitter emit) =>
      emit(DevicesUpdateSuccess(devices: List.from(_devices), selectedDeviceSerials: Set.from(_selectedDeviceSerials)));
}
