import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:scrcpy_buddy/application/model/adb/adb_device.dart';
import 'package:scrcpy_buddy/application/model/adb/adb_error.dart';
import 'package:scrcpy_buddy/service/adb_service.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

part 'devices_event.dart';
part 'devices_state.dart';

typedef _Emitter = Emitter<DevicesState>;

class DevicesBloc extends Bloc<DevicesEvent, DevicesState> {
  DevicesBloc(this._adbService, this._adbPath) : super(const DevicesInitial()) {
    on<LoadDevices>(_onLoadDevices);
    on<ToggleDeviceSelection>(_onToggleDeviceSelection);
  }

  bool _initDone = false;
  final AdbService _adbService;
  final List<AdbDevice> _devices = [];
  final Set<String> _selectedDeviceSerials = {};
  final Preference<String> _adbPath;

  Future<void> _onLoadDevices(LoadDevices event, _Emitter emit) async {
    try {
      emit(DevicesLoading());
      if (!_initDone) {
        final initResult = await _adbService.init(_adbPath.getValue());
        if (initResult.isLeft()) {
          final error = initResult.fold((l) => l, (r) => null);
          emit(
            DevicesUpdateError(
              devices: _devices,
              selectedDeviceSerials: _selectedDeviceSerials,
              adbError: error,
              message: error.toString(),
            ),
          );
          return;
        } else {
          _initDone = true;
        }
      }
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
