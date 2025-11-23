part of 'args_bloc.dart';

sealed class ArgsState extends Equatable {
  final Map<ScrcpyCliArgument, dynamic> args;

  // ignore: prefer_const_constructors_in_immutables
  ArgsState(this.args);

  @override
  List<Object?> get props {
    if (args.isEmpty) {
      return [Random().nextInt(9999)];
    } else {
      return args.entries.toList(growable: false);
    }
  }
}

final class ArgsInitial extends ArgsState {
  ArgsInitial(super.args);
}

final class ArgsUpdatedState extends ArgsState {
  ArgsUpdatedState(super.args);
}
