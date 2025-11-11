part of 'devices_bloc.dart';

sealed class DevicesEvent extends Equatable {
  const DevicesEvent();

  @override
  List<Object> get props => [];
}

final class LoadDevices extends DevicesEvent {}

final class ToggleDeviceSelection extends DevicesEvent {
  const ToggleDeviceSelection(this.deviceSerial);

  final String deviceSerial;

  @override
  List<Object> get props => [deviceSerial];
}
