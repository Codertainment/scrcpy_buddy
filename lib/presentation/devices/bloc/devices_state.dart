part of 'devices_bloc.dart';

sealed class DevicesState extends Equatable {
  const DevicesState();
}

final class DevicesInitial extends DevicesState {
  const DevicesInitial();

  @override
  List<Object> get props => [];
}

final class DevicesLoading extends DevicesState {
  const DevicesLoading();

  @override
  List<Object?> get props => [];
}

sealed class BaseDevicesUpdateState extends DevicesState {
  final List<AdbDevice> devices;
  final Set<String> selectedDeviceSerials;

  const BaseDevicesUpdateState({required this.devices, required this.selectedDeviceSerials});
}

final class DevicesUpdateSuccess extends BaseDevicesUpdateState {
  // ignore: prefer_const_constructors_in_immutables
  DevicesUpdateSuccess({required super.devices, required super.selectedDeviceSerials});

  @override
  List<Object?> get props => [devices, selectedDeviceSerials];

}

final class DevicesUpdateError extends BaseDevicesUpdateState {
  final AdbError? adbError;
  final String? message;

  const DevicesUpdateError({required super.devices, required super.selectedDeviceSerials, this.adbError, this.message});

  @override
  List<Object?> get props => [devices, selectedDeviceSerials, adbError, message];
}
