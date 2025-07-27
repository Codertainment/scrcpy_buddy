import 'package:kiwi/kiwi.dart';
import 'package:process/process.dart';
import 'package:scrcpy_buddy/service/adb_service.dart';

import 'application/adb_result_parser.dart';

part 'injector.g.dart';

abstract class Injector {
  @Register.singleton(ProcessManager, from: LocalProcessManager)
  @Register.singleton(AdbResultParser)
  @Register.singleton(AdbService)
  void configure();
}

class Di {
  static void setup() {
    final injector = _$Injector();
    injector.configure();
  }
}

T resolveDependency<T>() => KiwiContainer().resolve<T>();
