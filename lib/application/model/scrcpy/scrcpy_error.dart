sealed class ScrcpyError {
  const ScrcpyError();
}

class UnknownScrcpyError extends ScrcpyError {
  final Object? exception;

  const UnknownScrcpyError({this.exception});
}

class ScrcpyNotFoundError extends ScrcpyError {}

class ScrcpyKillError extends ScrcpyError {
  final Object? exception;

  const ScrcpyKillError({this.exception});
}

class ScrcpyListAppsError extends ScrcpyError {
  final String stdErr;

  const ScrcpyListAppsError(this.stdErr);

  @override
  String toString() {
    return stdErr;
  }
}
