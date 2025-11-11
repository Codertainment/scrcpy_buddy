part of 'args_bloc.dart';

sealed class ArgsEvent extends Equatable {
  const ArgsEvent();
}

class InitializeArgsEvent extends ArgsEvent {
  const InitializeArgsEvent();

  @override
  List<Object?> get props => [];
}

class UpdateArgsEvent<V> extends ArgsEvent {
  final String key;
  final V? value;

  const UpdateArgsEvent(this.key, this.value);

  @override
  List<Object?> get props => [key, value];
}
