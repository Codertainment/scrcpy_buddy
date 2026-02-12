import 'package:fpdart/fpdart.dart';

class ProcessStopError {
  final Object? exception;

  ProcessStopError([this.exception]);
}

typedef ProcessStopResult = Either<ProcessStopError, bool>;
