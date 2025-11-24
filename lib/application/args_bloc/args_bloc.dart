import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:scrcpy_buddy/application/model/scrcpy/scrcpy_cli_argument.dart';

part 'args_event.dart';

part 'args_state.dart';

typedef _Emitter = Emitter<ArgsState>;

class ArgsBloc extends Bloc<ArgsEvent, ArgsState> {
  ArgsBloc() : super(ArgsInitial({})) {
    on<UpdateArgsEvent>(_updateArg);
    on<InitializeArgsEvent>(_initializeArgs);
  }

  final _args = <ScrcpyCliArgument, dynamic>{};

  // final _argsInstances = scrcpyArg.annotatedClasses
  //     .map((c) => c.newInstance('', []) as ScrcpyCliArgument)
  //     .toList(growable: false);

  void _updateArg(UpdateArgsEvent event, _Emitter emit) {
    if (event.value == null) {
      _args.remove(event.arg);
    } else {
      _args[event.arg] = event.value;
    }
    emit(ArgsUpdatedState(_args));
  }

  void _initializeArgs(InitializeArgsEvent _, _Emitter emit) {
    // TODO: Load saved args/profiles
    emit(ArgsUpdatedState(_args));
  }
}
