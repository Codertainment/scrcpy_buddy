import 'package:equatable/equatable.dart';

abstract class ScrcpyCliArgument<V> extends Equatable {
  abstract final List<String>? values;
  abstract final String argument;
  abstract final String label;

  List<String> toArgs(V value);

  @override
  List<Object?> get props => [label];
}
