import 'dart:io';

import 'error_process_result.dart';

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

abstract class BaseProcessResultError extends AdbError {
  late final ErrorProcessResult processResult;

  BaseProcessResultError(ProcessResult processResult) {
    this.processResult = ErrorProcessResult(processResult);
  }

  String get message => processResult.message;
}

// Connect errors
class AdbConnectError extends BaseProcessResultError {
  AdbConnectError(super.processResult);
}

// get device IP Errors
class AdbGetDeviceIpError extends BaseProcessResultError {
  AdbGetDeviceIpError(super.processResult);
}

// switch device to TCPIP Error
class AdbSwitchToTcpIpError extends BaseProcessResultError {
  AdbSwitchToTcpIpError(super.processResult);
}
