import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:scrcpy_buddy/application/adb_result_parser.dart';
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
}
