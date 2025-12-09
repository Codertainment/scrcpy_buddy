import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:scrcpy_buddy/presentation/devices/devices_screen.dart';
import 'package:scrcpy_buddy/presentation/home/home_screen.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/audio/audio_screen.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/camera_screen.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/control/control_screen.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/device/device_screen.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/recording_screen.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/v4l2/v4l2_screen.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/video/video_screen.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/virtualDisplay/virtual_display_screen.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/window/window_screen.dart';
import 'package:scrcpy_buddy/presentation/settings/settings_screen.dart';

class AppRoute {
  AppRoute._();

  static const String devices = "/devices";

  static const String audio = "/scrcpyConfig.audio";
  static const String camera = "/scrcpyConfig.camera";
  static const String control = "/scrcpyConfig.control";
  static const String device = "/scrcpyConfig.device";
  static const String recording = "/scrcpyConfig.recording";
  static const String v4l2 = "/scrcpyConfig.v4l2";
  static const String video = "/scrcpyConfig.video";
  static const String virtualDisplay = "/scrcpyConfig.virtualDisplay";
  static const String window = "/scrcpyConfig.window";

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

        GoRoute(path: AppRoute.audio, builder: (_, _) => const AudioScreen()),
        GoRoute(path: AppRoute.camera, builder: (_, _) => const CameraScreen()),
        GoRoute(path: AppRoute.control, builder: (_, _) => const ControlScreen()),
        GoRoute(path: AppRoute.device, builder: (_, _) => const DeviceScreen()),
        GoRoute(path: AppRoute.recording, builder: (_, _) => const RecordingScreen()),
        GoRoute(path: AppRoute.v4l2, builder: (_, _) => const V4l2Screen()),
        GoRoute(path: AppRoute.video, builder: (_, _) => const VideoScreen()),
        GoRoute(path: AppRoute.virtualDisplay, builder: (_, _) => const VirtualDisplayScreen()),
        GoRoute(path: AppRoute.window, builder: (_, _) => const WindowScreen()),

        GoRoute(path: AppRoute.settings, builder: (_, _) => const SettingsScreen()),
      ],
    ),
  ],
);
