import 'package:fpdart/fpdart.dart';
import 'package:process/process.dart';
import 'package:scrcpy_buddy/application/adb_result_parser.dart';
import 'package:scrcpy_buddy/application/model/adb/adb_error.dart';
import 'package:scrcpy_buddy/application/model/adb/adb_result.dart';
import 'package:scrcpy_buddy/either_utils.dart';

class AdbService {
  final ProcessManager _processManager;
  final AdbResultParser _resultParser;

  AdbService(this._processManager, this._resultParser);

  Future<AdbVersionInfoResult> getVersionInfo(String? path) =>
      _resultParser.parseVersionInfoResult(_processManager.run([path ?? 'adb', '--version']));

  Future<AdbInitResult> init() => _resultParser.parseInitResult(_processManager.run(['adb', 'start-server']));

  Future<AdbDevicesResult> devices() => _resultParser.parseDevicesResult(_processManager.run(['adb', 'devices', '-l']));

  Future<AdbConnectResult> connect(String ip) =>
      _resultParser.parseConnectResult(_processManager.run(['adb', 'connect', ip]));

  Future<AdbDeviceIpResult> getDeviceIp(String serial) =>
      _resultParser.parseDeviceIpResult(_processManager.run(['adb', '-s', serial, 'shell', 'ip', 'route', 'show']));

  Future<void> tcpIp(String serial, [String port = "5555"]) =>
      _resultParser.parseTcpIpResult(_processManager.run(['adb', '-s', serial, 'tcpip', port]));

  Future<Either<AdbError, void>> disconnect(String serial) =>
      _resultParser.parseDisconnectResult(_processManager.run(['adb', 'disconnect', serial]));

  Future<AdbConnectResult> switchDeviceToTcpIp(String serial, [String port = "5555"]) async {
    final deviceIp = await getDeviceIp(serial);
    if (deviceIp.isLeft()) {
      return AdbConnectResult.left(deviceIp.getLeft().getOrElse(() => throw Exception("Failed to get device ip")));
    }
    try {
      await tcpIp(serial, port);
      return await connect(EitherUtils.getRight(deviceIp));
    } catch (e) {
      return AdbConnectResult.left(UnknownAdbError(exception: e));
    }
  }
}
