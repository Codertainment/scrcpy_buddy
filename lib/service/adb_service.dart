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

  Future<AdbVersionInfoResult> getVersionInfo(String path) =>
      _resultParser.parseVersionInfoResult(_processManager.run([_getExecutable(path), '--version']));

  Future<AdbInitResult> init(String path) =>
      _resultParser.parseInitResult(_processManager.run([_getExecutable(path), 'start-server']));

  Future<AdbDevicesResult> devices(String path) =>
      _resultParser.parseDevicesResult(_processManager.run([_getExecutable(path), 'devices', '-l']));

  Future<AdbConnectResult> connect(String ip, String path) =>
      _resultParser.parseConnectResult(_processManager.run([_getExecutable(path), 'connect', ip]));

  Future<AdbDeviceIpResult> getDeviceIp(String serial, String path) => _resultParser.parseDeviceIpResult(
    _processManager.run([_getExecutable(path), '-s', serial, 'shell', 'ip', 'route', 'show']),
  );

  Future<void> tcpIp(String serial, String path, [String port = "5555"]) =>
      _resultParser.parseTcpIpResult(_processManager.run([_getExecutable(path), '-s', serial, 'tcpip', port]));

  Future<Either<AdbError, void>> disconnect(String serial, String path) =>
      _resultParser.parseDisconnectResult(_processManager.run([_getExecutable(path), 'disconnect', serial]));

  Future<AdbConnectResult> switchDeviceToTcpIp(String serial, String path, [String port = "5555"]) async {
    final deviceIp = await getDeviceIp(serial, path);
    if (deviceIp.isLeft()) {
      return AdbConnectResult.left(deviceIp.getLeft().getOrElse(() => throw Exception("Failed to get device ip")));
    }
    try {
      await tcpIp(serial, path, port);
      return await connect(EitherUtils.getRight(deviceIp), path);
    } catch (e) {
      return AdbConnectResult.left(UnknownAdbError(exception: e));
    }
  }

  String _getExecutable(String path) => path.isNotEmpty ? path : 'adb';
}
