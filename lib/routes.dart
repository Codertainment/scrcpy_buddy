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

        GoRoute(path: AppRoute.audio, builder: _configRouteBuilder(const AudioScreen())),
        GoRoute(path: AppRoute.camera, builder: _configRouteBuilder(const CameraScreen())),
        GoRoute(path: AppRoute.control, builder: _configRouteBuilder(const ControlScreen())),
        GoRoute(path: AppRoute.device, builder: _configRouteBuilder(const DeviceScreen())),
        GoRoute(path: AppRoute.recording, builder: _configRouteBuilder(const RecordingScreen())),
        GoRoute(path: AppRoute.v4l2, builder: _configRouteBuilder(const V4l2Screen())),
        GoRoute(path: AppRoute.video, builder: _configRouteBuilder(const VideoScreen())),
        GoRoute(path: AppRoute.virtualDisplay, builder: _configRouteBuilder(const VirtualDisplayScreen())),
        GoRoute(path: AppRoute.window, builder: _configRouteBuilder(const WindowScreen())),

        GoRoute(path: AppRoute.profiles, builder: (_, _) => const ProfilesScreen()),
        GoRoute(path: AppRoute.settings, builder: (_, _) => const SettingsScreen()),
      ],
    ),
  ],
);

Widget Function(BuildContext context, GoRouterState state) _configRouteBuilder(Widget child) =>
    (_, state) => HighlightProvider(highlightLabel: state.extra as String?, child: child);
