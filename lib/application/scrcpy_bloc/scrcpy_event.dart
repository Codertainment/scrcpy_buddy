part of 'scrcpy_bloc.dart';

sealed class ScrcpyEvent extends Equatable {
  const ScrcpyEvent();
}

class StartScrcpyEvent extends ScrcpyEvent {
  final String deviceSerial;
  final List<String> args;

  const StartScrcpyEvent({required this.deviceSerial, required this.args});

  @override
  List<Object?> get props => [deviceSerial, args];
}

class StopScrcpyEvent extends ScrcpyEvent {
  final String deviceSerial;

  const StopScrcpyEvent({required this.deviceSerial});

  @override
  List<Object?> get props => [deviceSerial];
}
