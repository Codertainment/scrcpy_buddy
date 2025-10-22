part of 'devices_cubit.dart';

sealed class DevicesState extends Equatable {
  const DevicesState();
}

final class DevicesInitial extends DevicesState {
  @override
  List<Object> get props => [];
}

final class DevicesLoading extends DevicesState {
  @override
  List<Object?> get props => [];
}

final class DevicesLoadSuccess extends DevicesState {
  final List<AdbDevice> devices;

  const DevicesLoadSuccess(this.devices);

  @override
  List<Object?> get props => [devices];
}

final class DevicesLoadFailure extends DevicesState {
  final AdbError? adbError;
  final String? message;

  const DevicesLoadFailure({this.adbError, this.message});

  @override
  List<Object?> get props => [adbError, message];
}
