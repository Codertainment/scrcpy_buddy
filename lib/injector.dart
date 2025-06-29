import 'package:kiwi/kiwi.dart';
import 'package:scrcpy_buddy/service/adb_service.dart';

part 'injector.g.dart';

abstract class Injector {
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