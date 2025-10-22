import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:scrcpy_buddy/application/model/adb/adb_device.dart';
import 'package:scrcpy_buddy/application/model/adb/adb_error.dart';
import 'package:scrcpy_buddy/service/adb_service.dart';

part 'devices_state.dart';

class DevicesCubit extends Cubit<DevicesState> {
  DevicesCubit(this._adbService) : super(DevicesInitial());
  final AdbService _adbService;

  Future<void> loadDevices() async {
    try {
      emit(DevicesLoading());
      final initResult = await _adbService.init();
      initResult.mapLeft((error) => emit(DevicesLoadFailure(adbError: error, message: error.toString())));
      if (initResult.isLeft()) {
        return;
      }
      final devicesResult = await _adbService.devices();
      devicesResult.mapLeft((error) => emit(DevicesLoadFailure(adbError: error, message: error.toString())));
      devicesResult.map((devices) => emit(DevicesLoadSuccess(devices)));
    } catch (e) {
      emit(DevicesLoadFailure(message: e.toString()));
    }
  }
}
