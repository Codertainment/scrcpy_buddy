import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:scrcpy_buddy/presentation/devices/devices_screen.dart';
import 'package:scrcpy_buddy/presentation/home/home_screen.dart';
import 'package:scrcpy_buddy/presentation/profiles/profiles_screen.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/audio/audio_screen.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/camera_screen.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/control/control_screen.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/device/device_screen.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/recording_screen.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/v4l2/v4l2_screen.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/video/video_screen.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/virtualDisplay/virtual_display_screen.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/widgets/highlight_provider.dart';
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

  static const String profiles = "/profiles";
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

        GoRoute(
          path: AppRoute.audio,
          builder: (_, state) => HighlightProvider(highlightLabel: state.extra as String?, child: const AudioScreen()),
        ),
        GoRoute(
          path: AppRoute.camera,
          builder: (_, state) => HighlightProvider(highlightLabel: state.extra as String?, child: const CameraScreen()),
        ),
        GoRoute(
          path: AppRoute.control,
          builder: (_, state) =>
              HighlightProvider(highlightLabel: state.extra as String?, child: const ControlScreen()),
        ),
        GoRoute(
          path: AppRoute.device,
          builder: (_, state) => HighlightProvider(highlightLabel: state.extra as String?, child: const DeviceScreen()),
        ),
        GoRoute(
          path: AppRoute.recording,
          builder: (_, state) =>
              HighlightProvider(highlightLabel: state.extra as String?, child: const RecordingScreen()),
        ),
        GoRoute(
          path: AppRoute.v4l2,
          builder: (_, state) => HighlightProvider(highlightLabel: state.extra as String?, child: const V4l2Screen()),
        ),
        GoRoute(
          path: AppRoute.video,
          builder: (_, state) => HighlightProvider(highlightLabel: state.extra as String?, child: const VideoScreen()),
        ),
        GoRoute(
          path: AppRoute.virtualDisplay,
          builder: (_, state) =>
              HighlightProvider(highlightLabel: state.extra as String?, child: const VirtualDisplayScreen()),
        ),
        GoRoute(
          path: AppRoute.window,
          builder: (_, state) => HighlightProvider(highlightLabel: state.extra as String?, child: const WindowScreen()),
        ),

        GoRoute(path: AppRoute.profiles, builder: (_, _) => const ProfilesScreen()),
        GoRoute(path: AppRoute.settings, builder: (_, _) => const SettingsScreen()),
      ],
    ),
  ],
);
