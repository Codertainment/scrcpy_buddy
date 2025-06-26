import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:parameterized_test/parameterized_test.dart';
import 'package:scrcpy_buddy/application/adb_result_parser.dart';
import 'package:scrcpy_buddy/application/model/adb/adb_connect_result_status.dart';
import 'package:scrcpy_buddy/application/model/adb/adb_device.dart';
import 'package:scrcpy_buddy/application/model/adb/adb_error.dart';
import 'package:test/test.dart';

import '../fixtures/process_exception_fixture.dart';
import '../fixtures/process_result_fixture.dart';

void main() {
  final AdbResultParser parser = AdbResultParser();

  group('parseInitResult', () {
    test('Success', () async {
      final processResult = ProcessResultFixture.create(exitCode: 0);
      final result = await parser.parseInitResult(Future.value(processResult));
      expect(result.isRight(), true);
      expect(result.getRight().getOrElse(() => throw "Unknown Error"), processResult.exitCode);
    });

    test('Failed to find executable', () async {
      final processException = ProcessExceptionFixture.create(message: "failed to find");
      final result = await parser.parseInitResult(Future.error(processException));
      expect(result.isLeft(), true);
      final resultError = result.getLeft().getOrElse(() => throw "Unknown error");
      expect(resultError.runtimeType, AdbNotFoundError);
    });

    test('Unknown Process Exception', () async {
      final unknownProcessException = ProcessExceptionFixture.create();
      final result = await parser.parseInitResult(Future.error(unknownProcessException));
      final resultError = result.getLeft().getOrElse(() => throw "Unknown error");
      expect(resultError.runtimeType, UnknownAdbError);
    });

    test('Unknown Exception', () async {
      final ioException = SignalException("");
      final result = await parser.parseInitResult(Future.error(ioException));
      expect(result.isLeft(), true);
      final resultError = result.getLeft().getOrElse(() => throw "Unknown error");
      expect(resultError.runtimeType, UnknownAdbError);
    });
  });

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
