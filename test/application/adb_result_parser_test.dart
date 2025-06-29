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

  group('parseDevicesResult', () {
    test('Success', () async {
      final processResult = ProcessResultFixture.create(
        exitCode: 0,
        stdout: """List of devices attached
          192.168.179.14:5555    device product:shiba model:Pixel_8 device:shiba transport_id:1""",
      );
      final result = await parser.parseDevicesResult(Future.value(processResult));
      expect(result.isRight(), true);
      final devices = result.getRight().getOrElse(() => throw "Unknown Error");
      expect(devices.length, 1);
      expect(
        devices[0],
        AdbDevice(
          serial: "192.168.179.14:5555",
          status: AdbDeviceStatus.device,
          metadata: {"product": "shiba", "model": "Pixel_8", "device": "shiba", "transport_id": "1"},
        ),
      );
    });

    test('Success with no devices', () async {
      final processResult = ProcessResultFixture.create(exitCode: 0, stdout: "List of devices attached\n");
      final result = await parser.parseDevicesResult(Future.value(processResult));
      expect(result.isRight(), true);
      final devices = result.getRight().getOrElse(() => throw "Unknown Error");
      expect(devices.length, 0);
    });

    test('Failure', () async {
      final processResult = ProcessExceptionFixture.create();
      final result = await parser.parseDevicesResult(Future.error(processResult));
      expect(result.isLeft(), true);
      final resultError = result.getLeft().getOrElse(() => throw "Unknown error");
      expect(resultError.runtimeType, UnknownAdbError);
    });
  });

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

  group('parseConnectResult', () {
    test('Success', () async {
      final processResult = ProcessResultFixture.create(exitCode: 0);
      final result = await parser.parseConnectResult(Future.value(processResult));
      expect(result.isRight(), true);
      final connectResult = result.getRight().getOrElse(() => throw "Unknown Error");
      expect(connectResult, AdbConnectResultStatus.success);
    });
    test('pendingAuthorization', () async {
      final processResult = ProcessResultFixture.create(exitCode: 1, stdout: "failed to authenticate to");
      final result = await parser.parseConnectResult(Future.value(processResult));
      expect(result.isRight(), true);
      final connectResult = result.getRight().getOrElse(() => throw "Unknown Error");
      expect(connectResult, AdbConnectResultStatus.pendingAuthorization);
    });
    test('other connection error', () async {
      final processResult = ProcessResultFixture.create(exitCode: 1, stderr: "Connection refused");
      final result = await parser.parseConnectResult(Future.value(processResult));
      expect(result.isLeft(), true);
      final resultError = result.getLeft().getOrElse(() => throw "Unknown error");
      expect(resultError.runtimeType, AdbConnectError);
      expect((resultError as AdbConnectError).message, "Connection refused");
    });
  });
}
