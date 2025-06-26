import 'package:process/process.dart';
import 'package:scrcpy_buddy/application/adb_result_parser.dart';
import 'package:scrcpy_buddy/application/model/adb/adb_result.dart';

class AdbService {
  static final AdbService _instance = AdbService._internal();

  AdbService._internal();

  factory AdbService() {
    return _instance;
  }

  final _processManager = LocalProcessManager();
  final _resultParser = AdbResultParser();

  Future<AdbInitResult> init() => _resultParser.parseInitResult(_processManager.run(['adb', 'start-server']));

  Future<AdbDevicesResult> devices() => _resultParser.parseDevicesResult(_processManager.run(['adb', 'devices', '-l']));

  Future<AdbConnectResult> connect(String ip) => _resultParser.parseConnectResult(_processManager.run(['adb', 'connect', ip]));
}
