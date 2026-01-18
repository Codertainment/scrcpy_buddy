import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart' as flutter_acrylic;
import 'package:scrcpy_buddy/main.reflectable.dart';
import 'package:system_theme/system_theme.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

const _appName = "scrcpy buddy";

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeReflectable();

  // window init
  await flutter_acrylic.Window.initialize();
  if (defaultTargetPlatform == TargetPlatform.windows) {
    await flutter_acrylic.Window.setEffect(effect: flutter_acrylic.WindowEffect.acrylic);
  }
  await WindowManager.instance.ensureInitialized();
  if (kReleaseMode) {
    windowManager.setPreventClose(true);
  }
  windowManager.waitUntilReadyToShow().then((_) async {
    await windowManager.setMinimumSize(const Size(500, 600));
    await windowManager.setTitle(_appName);
    await windowManager.show();
  });

  // load system accent color
  await SystemTheme.accentColor.load();

  // tray icon init
  try {
    await trayManager.setIcon(Platform.isWindows ? 'assets/tray/icon.ico' : 'assets/tray/icon.png');
    if (Platform.isLinux) {
      // Don't show title on macOS (takes up more space in menu bar)
      // Not supported on Windows
      await trayManager.setTitle(_appName);
    } else {
      // tray_manager doesn't support this on linux
      await trayManager.setToolTip(_appName);
    }
  } catch (e, stack) {
    debugPrint(e.toString());
    debugPrintStack(stackTrace: stack);
  }
}
