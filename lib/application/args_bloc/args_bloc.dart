import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

// ignore: unused_import
import 'package:scrcpy_buddy/application/model/scrcpy/scrcpy_arg.dart';
import 'package:scrcpy_buddy/application/model/scrcpy/scrcpy_cli_argument.dart';
import 'package:scrcpy_buddy/main.dart';

part 'args_event.dart';

part 'args_state.dart';

typedef _Emitter = Emitter<ArgsState>;

class ArgsBloc extends Bloc<ArgsEvent, ArgsState> {
  ArgsBloc() : super(ArgsInitial()) {
    on<UpdateArgsEvent>(_updateArg);
    on<InitializeArgsEvent>(_initializeArgs);
  }

  final _args = <String, dynamic>{};

  final _argsInstances = scrcpyArg.annotatedClasses
      .map((c) => c.newInstance('', []) as ScrcpyCliArgument)
      .toList(growable: false);

  void _updateArg(UpdateArgsEvent event, _Emitter emit) {
    _args[event.key] = event.value;
    emit(ArgsUpdatedState(_args));
  }

  void _initializeArgs(InitializeArgsEvent _, _Emitter emit) {
    _args.putIfAbsent(VideoSize().label, () => "1280");
    emit(ArgsUpdatedState(_args));
  }

  List<String> calculateArgsList() => _args.keys
      .map((key) => _argsInstances.where((argInstance) => argInstance.label == key).first)
      .map((argumentInstance) => argumentInstance.toArgs(_args[argumentInstance.label]))
      .flatten
      .toList(growable: false);
}
