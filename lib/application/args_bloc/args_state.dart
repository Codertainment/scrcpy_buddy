part of 'args_bloc.dart';

sealed class ArgsState extends Equatable {
  const ArgsState();
}

final class ArgsInitial extends ArgsState {
  @override
  List<Object> get props => [];
}

final class ArgsUpdatedState extends ArgsState {
  final Map<String, dynamic> args;

  const ArgsUpdatedState(this.args);

  @override
  List<Object> get props => [args];
}
