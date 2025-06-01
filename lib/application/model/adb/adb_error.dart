sealed class AdbError {
  const AdbError();
}

class UnknownAdbError extends AdbError {
  final Object? exception;

  const UnknownAdbError({this.exception});
}

sealed class AdbInitError extends AdbError {}

class AdbNotFoundError extends AdbInitError {}
