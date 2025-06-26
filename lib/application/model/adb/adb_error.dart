sealed class AdbError {
  const AdbError();
}

class UnknownAdbError extends AdbError {
  final Object? exception;

  const UnknownAdbError({this.exception});
}

// Init errors
sealed class AdbInitError extends AdbError {}

class AdbNotFoundError extends AdbInitError {}

// Connect errors
class AdbConnectError extends AdbError {
  final String message;

  const AdbConnectError(this.message);
}
