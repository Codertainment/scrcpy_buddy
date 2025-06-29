import 'dart:io';

import 'package:equatable/equatable.dart';

class ErrorProcessResult extends Equatable {
  late final String stdout;
  late final String stderr;
  late final int exitCode;

  ErrorProcessResult(ProcessResult processResult) {
    exitCode = processResult.exitCode;
    stdout = processResult.stdout;
    stderr = processResult.stderr;
  }

  String get message => "$stdout\n$stderr";

  @override
  List<Object?> get props => [exitCode, stdout, stderr];
}
