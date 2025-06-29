import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:parameterized_test/parameterized_test.dart';
import 'package:scrcpy_buddy/application/adb_result_parser.dart';
import 'package:scrcpy_buddy/application/model/adb/adb_connect_result_status.dart';
import 'package:scrcpy_buddy/application/model/adb/adb_device.dart';
import 'package:scrcpy_buddy/application/model/adb/adb_error.dart';
import 'package:test/test.dart';

import '../description_parameterized_test.dart';
import '../fixtures/process_exception_fixture.dart';
import '../fixtures/process_result_fixture.dart';

typedef _ProcessResultSupplier = Future<ProcessResult> Function();

void main() {
  final AdbResultParser parser = AdbResultParser();

  descriptionParameterizedTest(
    'parseInitResult',
    [
      [
        "Success",
        () => Future<ProcessResult>.value(ProcessResultFixture.create(exitCode: 0)),
        Either<AdbError, int>.right(0),
        null,
      ],
      [
        'Failed to find executable',
        () => Future<ProcessResult>.error(ProcessExceptionFixture.create(message: "failed to find")),
        Either<AdbError, int>.left(AdbNotFoundError()),
        AdbNotFoundError,
      ],
      [
        'Unknown Process Exception',
        () => Future<ProcessResult>.error(ProcessExceptionFixture.create()),
        Either<AdbError, int>.left(UnknownAdbError()),
        UnknownAdbError,
      ],
      [
        'Unknown Exception',
        () => Future<ProcessResult>.error(SignalException("")),
        Either<AdbError, int>.left(UnknownAdbError()),
        UnknownAdbError,
      ],
    ],
    (_, _ProcessResultSupplier processResultSupplier, Either<AdbError, int> expectedResult, expectedErrorType) async {
      final result = await parser.parseInitResult(processResultSupplier());
      expect(result.isRight(), expectedResult.isRight());
      if (expectedResult.isRight()) {
        expect(
          result.getRight().getOrElse(() => throw "Unknown Error"),
          expectedResult.getRight().getOrElse(() => throw "Unknown Error"),
        );
      } else {
        expect(result.getLeft().getOrElse(() => throw "Unknown error").runtimeType, expectedErrorType);
      }
    },
  );

  descriptionParameterizedTest(
    'parseDevicesResult',
    [
      [
        'Success',
        () => Future<ProcessResult>.value(
          ProcessResultFixture.create(
            exitCode: 0,
            stdout: """List of devices attached
          192.168.179.14:5555    device product:shiba model:Pixel_8 device:shiba transport_id:1""",
          ),
        ),
        Either<AdbError, List<AdbDevice>>.right([
          AdbDevice(
            serial: "192.168.179.14:5555",
            status: AdbDeviceStatus.device,
            metadata: {"product": "shiba", "model": "Pixel_8", "device": "shiba", "transport_id": "1"},
          ),
        ]),
        null,
      ],
      [
        'Success with no devices',
        () =>
            Future<ProcessResult>.value(ProcessResultFixture.create(exitCode: 0, stdout: "List of devices attached\n")),
        Either<AdbError, List<AdbDevice>>.right([]),
        null,
      ],
      [
        'Failure',
        () => Future<ProcessResult>.error(ProcessExceptionFixture.create()),
        Either<AdbError, List<AdbDevice>>.left(UnknownAdbError()),
        UnknownAdbError,
      ],
    ],
    (
      _,
      _ProcessResultSupplier processResultSupplier,
      Either<AdbError, List<AdbDevice>> expectedResult,
      expectedErrorType,
    ) async {
      final result = await parser.parseDevicesResult(processResultSupplier());
      expect(result.isRight(), expectedResult.isRight());
      if (expectedResult.isRight()) {
        final devices = result.getRight().getOrElse(() => throw "Unknown Error");
        final expectedDevices = expectedResult.getRight().getOrElse(() => throw "Unknown Error");
        expect(devices.length, expectedDevices.length);
        if (devices.isNotEmpty) {
          expect(devices[0], expectedDevices[0]);
        }
      } else {
        expect(result.getLeft().getOrElse(() => throw "Unknown error").runtimeType, expectedErrorType);
      }
    },
  );

  parameterizedTest(
    'parseMetadata',
    [
      [<String>[], <String, String>{}],
      [
        ['key1:value1', 'key2:value2'],
        {'key1': 'value1', 'key2': 'value2'},
      ],
      [
        ['key1:value1:value2', 'key2'],
        {'key1': 'value1'},
      ],
    ],
    (List<String> input, Map<String, String> expected) {
      final result = parser.parseMetadata(input);
      expect(result, expected);
    },
  );

  descriptionParameterizedTest(
    'parseConnectResult',
    [
      [
        "Success",
        () => Future<ProcessResult>.value(ProcessResultFixture.create(exitCode: 0)),
        Either<AdbError, AdbConnectResultStatus>.right(AdbConnectResultStatus.success),
        null,
      ],
      [
        'pendingAuthorization',
        () =>
            Future<ProcessResult>.value(ProcessResultFixture.create(exitCode: 1, stdout: "failed to authenticate to")),
        Either<AdbError, AdbConnectResultStatus>.right(AdbConnectResultStatus.pendingAuthorization),
        null,
      ],
      [
        'other connection error',
        () => Future<ProcessResult>.value(ProcessResultFixture.create(exitCode: 1, stderr: "Connection refused")),
        Either<AdbError, AdbConnectResultStatus>.left(AdbConnectError("Connection refused")),
        AdbConnectError,
      ],
    ],
    (
      _,
      _ProcessResultSupplier processResultSupplier,
      Either<AdbError, AdbConnectResultStatus> expectedResult,
      expectedErrorType,
    ) async {
      final result = await parser.parseConnectResult(processResultSupplier());
      expect(result.isRight(), expectedResult.isRight());
      if (expectedResult.isRight()) {
        expect(
          result.getRight().getOrElse(() => throw "Unknown Error"),
          expectedResult.getRight().getOrElse(() => throw "Unknown Error"),
        );
      } else {
        final resultError = result.getLeft().getOrElse(() => throw "Unknown error");
        final expectedError = expectedResult.getLeft().getOrElse(() => throw "Unknown error");
        expect(resultError.runtimeType, expectedErrorType);
        if (resultError is AdbConnectError && expectedError is AdbConnectError) {
          expect(resultError.message, expectedError.message);
        }
      }
    },
  );

  descriptionParameterizedTest(
    'parseDeviceIpResult',
    [
      [
        "Success",
        () => Future<ProcessResult>.value(
          ProcessResultFixture.create(
            exitCode: 0,
            stdout: "192.168.179.0/24 dev wlan1 proto kernel scope link src 192.168.179.9",
          ),
        ),
        Either<AdbError, String>.right("192.168.179.9"),
        null,
      ],
      [
        'Non-zero exit code',
        () => Future<ProcessResult>.value(ProcessResultFixture.create(exitCode: 1, stdout: "stdout", stderr: "stderr")),
        Either<AdbError, String>.left(AdbGetDeviceIpError("stdout\nstderr")),
        AdbGetDeviceIpError,
      ],
      [
        'Failure',
        () => Future<ProcessResult>.error(ProcessExceptionFixture.create()),
        Either<AdbError, String>.left(UnknownAdbError()),
        UnknownAdbError,
      ],
    ],
    (
      _,
      _ProcessResultSupplier processResultSupplier,
      Either<AdbError, String> expectedResult,
      expectedErrorType,
    ) async {
      final result = await parser.parseDeviceIpResult(processResultSupplier());
      expect(result.isRight(), expectedResult.isRight());
      if (expectedResult.isRight()) {
        expect(
          result.getRight().getOrElse(() => throw "Unknown Error"),
          expectedResult.getRight().getOrElse(() => throw "Unknown Error"),
        );
      } else {
        final resultError = result.getLeft().getOrElse(() => throw "Unknown error");
        final expectedError = expectedResult.getLeft().getOrElse(() => throw "Unknown error");
        expect(resultError.runtimeType, expectedErrorType);
        if (resultError is AdbGetDeviceIpError && expectedError is AdbGetDeviceIpError) {
          expect(resultError.message, expectedError.message);
        }
      }
    },
  );
}
