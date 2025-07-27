import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:process/process.dart'; // Import ProcessResult
import 'package:scrcpy_buddy/application/adb_result_parser.dart';
import 'package:scrcpy_buddy/application/model/adb/adb_connect_result_status.dart';
import 'package:scrcpy_buddy/application/model/adb/adb_device.dart';
import 'package:scrcpy_buddy/application/model/adb/adb_error.dart';
import 'package:scrcpy_buddy/application/model/adb/adb_result.dart';
import 'package:scrcpy_buddy/service/adb_service.dart';

import 'adb_service_test.mocks.dart';

// Helper for a generic dummy error
AdbError _createDummyAdbError() => UnknownAdbError(exception: Exception('dummy error'));

@GenerateMocks([ProcessManager, AdbResultParser])
void main() {
  late AdbService adbService;
  late MockProcessManager mockProcessManager;
  late MockAdbResultParser mockAdbResultParser;

  setUp(() {
    mockProcessManager = MockProcessManager();
    mockAdbResultParser = MockAdbResultParser();
    adbService = AdbService(mockProcessManager, mockAdbResultParser);
  });
  setUpAll(() {
    // For AdbDeviceIpResult (Either<AdbError, String>)
    provideDummy<Either<AdbError, String>>(Left(_createDummyAdbError()));

    // For AdbConnectResult (Either<AdbError, AdbConnectResultStatus>)
    provideDummy<Either<AdbError, AdbConnectResultStatus>>(Left(_createDummyAdbError()));

    // For AdbInitResult (Either<AdbError, Unit>) - assuming Unit is from fpdart
    provideDummy<Either<AdbError, Unit>>(Left(_createDummyAdbError()));

    // For AdbDevicesResult (Either<AdbError, List<AdbDevice>>)
    provideDummy<Either<AdbError, List<AdbDevice>>>(Left(_createDummyAdbError()));
  });

  group('AdbService', () {
    group('switchDeviceToTcpIp', () {
      const serial = 'emulator-5554';
      const customPort = '5556';
      const deviceIp = '192.168.1.102';
      const defaultPort = '5555';

      // Helper to set up common mocks for process manager runs
      void arrangeProcessRun(List<String> command, ProcessResult result) {
        when(mockProcessManager.run(command)).thenAnswer((_) async => result);
      }

      // Helper to set up common mocks for parser results
      void arrangeParseDeviceIp(ProcessResult forProcessResult, AdbDeviceIpResult returnsResult) {
        when(mockAdbResultParser.parseDeviceIpResult(any)).thenAnswer((_) async => returnsResult);
      }

      void arrangeParseTcpIp(ProcessResult forProcessResult) {
        when(mockAdbResultParser.parseTcpIpResult(any)).thenAnswer((_) async {});
      }

      void arrangeParseTcpIpThrows(ProcessResult forProcessResult, Object exceptionToThrow) {
        when(mockAdbResultParser.parseTcpIpResult(any)).thenThrow(exceptionToThrow);
      }

      void arrangeParseConnect(ProcessResult forProcessResult, AdbConnectResult returnsResult) {
        when(mockAdbResultParser.parseConnectResult(any)).thenAnswer((_) async => returnsResult);
      }

      test('should use default port 5555 if no port is provided and succeed', () async {
        // Arrange
        final getIpCommand = ['adb', '-d', serial, 'shell', 'ip', 'route', 'show'];
        final tcpIpCommand = ['adb', '-d', serial, 'tcpip', defaultPort]; // Using default port
        final connectCommand = ['adb', 'connect', '$deviceIp:$defaultPort'];

        final fakeGetIpProcessResult = ProcessResult(1, 0, 'default via $deviceIp dev eth0', '');
        final fakeTcpIpProcessResult = ProcessResult(2, 0, 'restarting in TCP mode port: $defaultPort', '');
        final fakeConnectProcessResult = ProcessResult(3, 0, 'connected to $deviceIp:$defaultPort', '');

        arrangeProcessRun(getIpCommand, fakeGetIpProcessResult);
        arrangeProcessRun(tcpIpCommand, fakeTcpIpProcessResult);
        arrangeProcessRun(connectCommand.take(3).toList(), fakeConnectProcessResult); // Adjust if connect includes port

        arrangeParseDeviceIp(fakeGetIpProcessResult, AdbDeviceIpResult.right(deviceIp));
        arrangeParseTcpIp(fakeTcpIpProcessResult);
        arrangeParseConnect(fakeConnectProcessResult, AdbConnectResult.right(AdbConnectResultStatus.success));

        // Act
        final result = await adbService.switchDeviceToTcpIp(serial); // No port provided

        // Assert
        expect(result.isRight(), isTrue);
        final capturedGetIpFuture = verify(mockProcessManager.run(getIpCommand)).captured.single;
        verify(mockAdbResultParser.parseDeviceIpResult(capturedGetIpFuture as Future<ProcessResult>)).called(1);

        final capturedTcpIpFuture = verify(mockProcessManager.run(tcpIpCommand)).captured.single;
        verify(mockAdbResultParser.parseTcpIpResult(capturedTcpIpFuture as Future<ProcessResult>)).called(1);

        final capturedConnectFuture = verify(mockProcessManager.run(connectCommand.take(3).toList())).captured.single;
        verify(mockAdbResultParser.parseConnectResult(capturedConnectFuture as Future<ProcessResult>)).called(1);
      });

      test('should succeed with custom port', () async {
        // Arrange (Similar to the existing success test but ensures custom port is used)
        final getIpCommand = ['adb', '-d', serial, 'shell', 'ip', 'route', 'show'];
        final tcpIpCommand = ['adb', '-d', serial, 'tcpIp', customPort];
        final connectCommand = ['adb', 'connect', '$deviceIp:$customPort'];

        final fakeGetIpProcessResult = ProcessResult(1, 0, 'default via $deviceIp dev eth0', '');
        final fakeTcpIpProcessResult = ProcessResult(2, 0, 'restarting in TCP mode port: $customPort', '');
        final fakeConnectProcessResult = ProcessResult(3, 0, 'connected to $deviceIp:$customPort', '');

        arrangeProcessRun(getIpCommand, fakeGetIpProcessResult);
        arrangeProcessRun(tcpIpCommand, fakeTcpIpProcessResult);
        arrangeProcessRun(connectCommand.take(3).toList(), fakeConnectProcessResult);

        arrangeParseDeviceIp(fakeGetIpProcessResult, AdbDeviceIpResult.right(deviceIp));
        arrangeParseTcpIp(fakeTcpIpProcessResult);
        arrangeParseConnect(fakeConnectProcessResult, AdbConnectResult.right(AdbConnectResultStatus.success));

        // Act
        final result = await adbService.switchDeviceToTcpIp(serial, customPort);

        // Assert
        expect(result.isRight(), isTrue);
        final capturedGetIpFuture = verify(mockProcessManager.run(getIpCommand)).captured.single;
        verify(mockAdbResultParser.parseDeviceIpResult(capturedGetIpFuture as Future<ProcessResult>)).called(1);

        final capturedTcpIpFuture = verify(mockProcessManager.run(tcpIpCommand)).captured.single;
        verify(mockAdbResultParser.parseTcpIpResult(capturedTcpIpFuture as Future<ProcessResult>)).called(1);

        final capturedConnectFuture = verify(mockProcessManager.run(connectCommand.take(3).toList())).captured.single;
        verify(mockAdbResultParser.parseConnectResult(capturedConnectFuture as Future<ProcessResult>)).called(1);
      });

      test('should return AdbConnectResult.left if getDeviceIp parser returns Left', () async {
        // Arrange
        final getIpCommand = ['adb', '-d', serial, 'shell', 'ip', 'route', 'show'];
        final fakeGetIpProcessResult = ProcessResult(1, 1, '', 'error getting ip'); // Simulate command failure
        final getIpError = AdbGetDeviceIpError(fakeGetIpProcessResult);

        arrangeProcessRun(getIpCommand, fakeGetIpProcessResult);
        arrangeParseDeviceIp(fakeGetIpProcessResult, AdbDeviceIpResult.left(getIpError));

        // Act
        final result = await adbService.switchDeviceToTcpIp(serial, customPort);

        // Assert
        expect(result.isLeft(), isTrue);
        expect(result.getLeft().getOrElse(() => throw "Expected error"), getIpError);

        final capturedGetIpFuture = verify(mockProcessManager.run(getIpCommand)).captured.single;
        verify(mockAdbResultParser.parseDeviceIpResult(capturedGetIpFuture as Future<ProcessResult>)).called(1);
        verifyNever(mockProcessManager.run(argThat(contains('tcpip'))));
        verifyNever(mockAdbResultParser.parseTcpIpResult(any));
        verifyNever(mockProcessManager.run(argThat(contains('connect'))));
        verifyNever(mockAdbResultParser.parseConnectResult(any));
      });

      test(
        'should return AdbConnectResult.left with UnknownAdbError if tcpIp parser throws generic Exception',
        () async {
          // Arrange
          final getIpCommand = ['adb', '-d', serial, 'shell', 'ip', 'route', 'show'];
          final tcpIpCommand = ['adb', '-d', serial, 'tcpip', customPort];

          final fakeGetIpProcessResult = ProcessResult(1, 0, 'default via $deviceIp dev eth0', '');
          final fakeTcpIpProcessResult = ProcessResult(
            2,
            1,
            '',
            'tcpip command failed',
          ); // Simulate underlying command failure
          final genericException = Exception("Generic parser failure for tcpip");

          arrangeProcessRun(getIpCommand, fakeGetIpProcessResult);
          arrangeProcessRun(tcpIpCommand, fakeTcpIpProcessResult);

          arrangeParseDeviceIp(fakeGetIpProcessResult, AdbDeviceIpResult.right(deviceIp));
          // Crucially, mock the *parser* to throw, simulating an issue within the parser logic for tcpIp
          arrangeParseTcpIpThrows(fakeTcpIpProcessResult, genericException);

          // Act
          final result = await adbService.switchDeviceToTcpIp(serial, customPort);

          // Assert
          expect(result.isLeft(), isTrue);
          final error = result.getLeft().getOrElse(() => throw "Expected error");
          expect(error, isA<UnknownAdbError>());
          expect((error as UnknownAdbError).exception, genericException);

          final capturedGetIpFuture = verify(mockProcessManager.run(getIpCommand)).captured.single;
          verify(mockAdbResultParser.parseDeviceIpResult(capturedGetIpFuture as Future<ProcessResult>)).called(1);
          final capturedTcpIpFuture = verify(mockProcessManager.run(tcpIpCommand)).captured.single;
          verify(
            mockAdbResultParser.parseTcpIpResult(capturedTcpIpFuture as Future<ProcessResult>),
          ).called(1); // Parser is called before it throws
          verifyNever(mockProcessManager.run(argThat(contains('connect'))));
          verifyNever(mockAdbResultParser.parseConnectResult(any));
        },
      );

      test(
        'should return AdbConnectResult.left with UnknownAdbError if AdbSwitchToTcpIpError is thrown by tcpIp parser',
        () async {
          // This test is important because AdbService catches generic Exception from tcpIp,
          // so we need to ensure AdbSwitchToTcpIpError (which is an Exception) is also handled.
          final getIpCommand = ['adb', '-d', serial, 'shell', 'ip', 'route', 'show'];
          final tcpIpCommand = ['adb', '-d', serial, 'tcpip', customPort];

          final fakeGetIpProcessResult = ProcessResult(1, 0, 'default via $deviceIp dev eth0', '');
          final fakeTcpIpProcessResult = ProcessResult(
            2,
            1,
            '',
            'error switching to tcpip mode',
          ); // Actual ProcessResult for the error
          final adbSwitchError = AdbSwitchToTcpIpError(fakeTcpIpProcessResult);

          arrangeProcessRun(getIpCommand, fakeGetIpProcessResult);
          arrangeProcessRun(tcpIpCommand, fakeTcpIpProcessResult);

          arrangeParseDeviceIp(fakeGetIpProcessResult, AdbDeviceIpResult.right(deviceIp));
          // Mock the parser to throw AdbSwitchToTcpIpError
          arrangeParseTcpIpThrows(fakeTcpIpProcessResult, adbSwitchError);

          // Act
          final result = await adbService.switchDeviceToTcpIp(serial, customPort);

          // Assert
          expect(result.isLeft(), isTrue);
          final error = result.getLeft().getOrElse(() => throw "Expected error");
          expect(error, isA<UnknownAdbError>());
          expect((error as UnknownAdbError).exception, adbSwitchError);

          final capturedGetIpFuture = verify(mockProcessManager.run(getIpCommand)).captured.single;
          verify(mockAdbResultParser.parseDeviceIpResult(capturedGetIpFuture as Future<ProcessResult>)).called(1);
          final capturedTcpIpFuture = verify(mockProcessManager.run(tcpIpCommand)).captured.single;
          verify(mockAdbResultParser.parseTcpIpResult(capturedTcpIpFuture as Future<ProcessResult>)).called(1);
          verifyNever(mockProcessManager.run(argThat(contains('connect'))));
          verifyNever(mockAdbResultParser.parseConnectResult(any));
        },
      );

      test('should return AdbConnectResult.left if connect parser returns Left', () async {
        // Arrange
        final getIpCommand = ['adb', '-d', serial, 'shell', 'ip', 'route', 'show'];
        final tcpIpCommand = ['adb', '-d', serial, 'tcpip', customPort];
        final connectCommand = ['adb', 'connect', '$deviceIp:$customPort'];

        final fakeGetIpProcessResult = ProcessResult(1, 0, 'default via $deviceIp dev eth0', '');
        final fakeTcpIpProcessResult = ProcessResult(2, 0, 'restarting in TCP mode port: $customPort', '');
        final fakeConnectProcessResult = ProcessResult(3, 1, '', 'failed to connect'); // Simulate connect failure
        final connectError = AdbConnectError(fakeConnectProcessResult);

        arrangeProcessRun(getIpCommand, fakeGetIpProcessResult);
        arrangeProcessRun(tcpIpCommand, fakeTcpIpProcessResult);
        arrangeProcessRun(connectCommand.take(3).toList(), fakeConnectProcessResult);

        arrangeParseDeviceIp(fakeGetIpProcessResult, AdbDeviceIpResult.right(deviceIp));
        arrangeParseTcpIp(fakeTcpIpProcessResult);
        arrangeParseConnect(fakeConnectProcessResult, AdbConnectResult.left(connectError));

        // Act
        final result = await adbService.switchDeviceToTcpIp(serial, customPort);

        // Assert
        expect(result.isLeft(), isTrue);
        expect(result.getLeft().getOrElse(() => throw "Expected error"), connectError);

        final capturedGetIpFuture = verify(mockProcessManager.run(getIpCommand)).captured.single;
        verify(mockAdbResultParser.parseDeviceIpResult(capturedGetIpFuture as Future<ProcessResult>)).called(1);
        final capturedTcpIpFuture = verify(mockProcessManager.run(tcpIpCommand)).captured.single;
        verify(mockAdbResultParser.parseTcpIpResult(capturedTcpIpFuture as Future<ProcessResult>)).called(1);
        final capturedConnectFuture = verify(mockProcessManager.run(connectCommand.take(3).toList())).captured.single;
        verify(mockAdbResultParser.parseConnectResult(capturedConnectFuture as Future<ProcessResult>)).called(1);
      });

      test('should correctly use default port in connect command when no port is provided to switchDeviceToTcpIp', () async {
        // Arrange
        final getIpCommand = ['adb', '-d', serial, 'shell', 'ip', 'route', 'show'];
        final tcpIpCommand = ['adb', '-d', serial, 'tcpip', defaultPort];
        // Crucially, the connect command in AdbService will be `connect(deviceIp)`,
        // but the actual `adb connect` might need `ip:port`.
        // Your AdbService.connect(ip) doesn't add the port, it expects the IP to be "ip:port" already if needed.
        // However, switchDeviceToTcpIp *does* construct the "ip:port" string before calling this.connect.
        // Let's assume your AdbService.connect() method internally expects just the IP if it's a raw IP,
        // or ip:port if that's what was passed.
        // The current implementation of switchDeviceToTcpIp is:
        // return await connect(EitherUtils.getRight(deviceIp));
        // This implies deviceIp from getDeviceIp IS NOT ip:port.
        // And tcpIp(serial, port) is called, then connect(deviceIp).
        // The AdbService.connect(String ip) method runs `adb connect ip`.
        // This means the `deviceIp` obtained from `getDeviceIp` is used directly.
        // Let's re-verify AdbService:
        // Future<AdbConnectResult> connect(String ip) => _resultParser.parseConnectResult(_processManager.run(['adb', 'connect', ip]));
        // Future<AdbConnectResult> switchDeviceToTcpIp(...) { ... return await connect(EitherUtils.getRight(deviceIp)); }
        // This implies the `deviceIp` string itself should be just the IP, and `adb connect <ip>` is run.
        // ADB CLI typically handles `adb connect <ip>` and `adb connect <ip>:<port>`
        // Let's assume the simplest case: `connect` is called with just the IP.

        // The key part in `switchDeviceToTcpIp` for the `connect` call is:
        // `return await connect(EitherUtils.getRight(deviceIp));`
        // The `port` argument of `switchDeviceToTcpIp` is used for the `tcpip` command,
        // but NOT directly for formatting the string passed to `this.connect()`.
        // The `connect` method takes the raw IP. The ADB daemon on the host handles the port previously set by `tcpip`.

        final connectCommandAdb = ['adb', 'connect', deviceIp]; // The command AdbService.connect will run

        final fakeGetIpProcessResult = ProcessResult(1, 0, 'default via $deviceIp dev eth0', '');
        final fakeTcpIpProcessResult = ProcessResult(2, 0, 'restarting in TCP mode port: $defaultPort', '');
        final fakeConnectProcessResult = ProcessResult(
          3,
          0,
          'connected to $deviceIp:$defaultPort',
          '',
        ); // ADB might respond with the port

        arrangeProcessRun(getIpCommand, fakeGetIpProcessResult);
        arrangeProcessRun(tcpIpCommand, fakeTcpIpProcessResult);
        arrangeProcessRun(connectCommandAdb, fakeConnectProcessResult); // This is what AdbService.connect runs

        arrangeParseDeviceIp(fakeGetIpProcessResult, AdbDeviceIpResult.right(deviceIp));
        arrangeParseTcpIp(fakeTcpIpProcessResult);
        arrangeParseConnect(fakeConnectProcessResult, AdbConnectResult.right(AdbConnectResultStatus.success));

        // Act
        await adbService.switchDeviceToTcpIp(serial); // No port, so default for tcpip

        // Assert
        // Verify tcpip command used defaultPort
        verify(mockProcessManager.run(tcpIpCommand)).called(1);
        // Verify connect command used the raw deviceIp
        final capturedConnectFuture = verify(mockProcessManager.run(connectCommandAdb)).captured.single;
        verify(mockAdbResultParser.parseConnectResult(capturedConnectFuture as Future<ProcessResult>)).called(1);
      });
    });
  }, skip: true);
}
