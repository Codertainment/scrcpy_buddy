import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart' as flutter_acrylic;
import 'package:scrcpy_buddy/main.reflectable.dart';
import 'package:system_theme/system_theme.dart';
import 'package:window_manager/window_manager.dart';

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeReflectable();

  // window init
  await flutter_acrylic.Window.initialize();
  if (defaultTargetPlatform == TargetPlatform.windows) {
    await flutter_acrylic.Window.setEffect(effect: flutter_acrylic.WindowEffect.acrylic);
  }
  await WindowManager.instance.ensureInitialized();
  windowManager.waitUntilReadyToShow().then((_) async {
    await windowManager.setMinimumSize(const Size(500, 600));
    await windowManager.show();
  });

  // load system accent color
  await SystemTheme.accentColor.load();
}
