part of 'scrcpy_bloc.dart';

sealed class ScrcpyState extends Equatable {
  const ScrcpyState();
}

final class ScrcpyInitial extends ScrcpyState {
  @override
  List<Object> get props => [];
}

sealed class ScrcpyBaseUpdateState extends ScrcpyState {
  final List<String> devices;

  const ScrcpyBaseUpdateState({required this.devices});
}

final class ScrcpyStartSuccessState extends ScrcpyBaseUpdateState {
  final String deviceSerial;

  const ScrcpyStartSuccessState({required this.deviceSerial, required super.devices});

  @override
  List<Object?> get props => [deviceSerial, devices];
}

final class ScrcpyStartFailedState extends ScrcpyBaseUpdateState {
  final String deviceSerial;
  final ScrcpyError error;

  const ScrcpyStartFailedState({required this.deviceSerial, required this.error, required super.devices});

  @override
  List<Object?> get props => [deviceSerial, error, devices];
}

final class ScrcpyStopSuccessState extends ScrcpyBaseUpdateState {
  final String deviceSerial;

  const ScrcpyStopSuccessState({required this.deviceSerial, required super.devices});

  @override
  List<Object?> get props => [deviceSerial, devices];
}

final class ScrcpyStopFailedState extends ScrcpyBaseUpdateState {
  final String deviceSerial;
  final ScrcpyError error;

  const ScrcpyStopFailedState({required this.deviceSerial, required this.error, required super.devices});

  @override
  List<Object?> get props => [deviceSerial, error, devices];
}
