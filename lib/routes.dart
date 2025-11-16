import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:scrcpy_buddy/presentation/devices/devices_screen.dart';
import 'package:scrcpy_buddy/presentation/home/home_screen.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/video_screen.dart';
import 'package:scrcpy_buddy/presentation/settings/setings_screen.dart';

class AppRoute {
  AppRoute._();

  static const String devices = "/devices";
  static const String video = "/scrcpyConfig.video";
  static const String settings = "/settings";
}

final rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();
final router = GoRouter(
  initialLocation: AppRoute.devices,
  navigatorKey: rootNavigatorKey,
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return HomeScreen(
          // shellContext: _shellNavigatorKey.currentContext,
          child: child,
        );
      },
      routes: [
        GoRoute(path: AppRoute.devices, builder: (_, _) => const DevicesScreen()),
        GoRoute(path: AppRoute.video, builder: (_, _) => const VideoScreen()),
        GoRoute(path: AppRoute.settings, builder: (_, _) => const SettingsScreen()),
      ],
    ),
  ],
);
