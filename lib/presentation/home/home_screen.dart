import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrcpy_buddy/application/model/scrcpy/scrcpy_error.dart';
import 'package:scrcpy_buddy/application/profiles_bloc/profiles_bloc.dart';
import 'package:scrcpy_buddy/application/scrcpy_bloc/scrcpy_bloc.dart';
import 'package:scrcpy_buddy/presentation/devices/bloc/devices_bloc.dart';
import 'package:scrcpy_buddy/presentation/extension/context_extension.dart';
import 'package:scrcpy_buddy/presentation/extension/translation_extension.dart';
import 'package:scrcpy_buddy/presentation/home/console_section/console_section.dart';
import 'package:scrcpy_buddy/presentation/home/widgets/console_dialog.dart';
import 'package:scrcpy_buddy/presentation/home/widgets/profile_button.dart';
import 'package:scrcpy_buddy/presentation/home/widgets/start_button.dart';
import 'package:scrcpy_buddy/presentation/home/widgets/stop_button.dart';
import 'package:scrcpy_buddy/presentation/widgets/app_widgets.dart';
import 'package:scrcpy_buddy/routes.dart';
import 'package:scrcpy_buddy/service/navigation_service.dart';
import 'package:scrcpy_buddy/service/running_process_manager.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.child});

  final Widget child;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends AppModuleState<HomeScreen> with WindowListener, TrayListener {
  late final _profilesBloc = context.read<ProfilesBloc>();
  late final _devicesBloc = context.read<DevicesBloc>();
  late final _runningProcessManager = context.read<RunningProcessManager>();
  final _navigationService = NavigationService();

  StreamSubscription? _trackDevicesUpdateSubscription;

  @override
  String get module => 'home';

  @override
  void initState() {
    super.initState();
    _profilesBloc.add(InitializeProfilesEvent());
    _devicesBloc.add(InitDeviceTracking());

    trayManager.addListener(this);
    windowManager.addListener(this);

    // wait for context to be initialized before loading translations
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => trayManager.setContextMenu(
        Menu(
          items: [
            MenuItem(
              label: translatedText(key: 'tray.showApp'),
              onClick: (menuItem) => _showWindow(),
            ),
            MenuItem(
              label: translatedText(key: 'tray.quit'),
              onClick: (menuItem) => _exitApp(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void onWindowClose() async {
    if (kReleaseMode) {
      windowManager.hide();
    } else {
      _exitApp();
    }
  }

  @override
  void onTrayIconMouseDown() {
    _showWindow();
  }

  void _showWindow() {
    windowManager.show(); // Restore window
    windowManager.focus();
  }

  void _exitApp() {
    trayManager.destroy();
    windowManager.destroy();
    SystemNavigator.pop(animated: true);
  }

  @override
  void onTrayIconRightMouseDown() {
    trayManager.popUpContextMenu();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    trayManager.removeListener(this);
    _trackDevicesUpdateSubscription?.cancel();
    super.dispose();
  }

  void _onTrackDevicesUpdateReceived() => _devicesBloc.add(LoadDevices());

  void _showUnexpectedStopInfoBar(ScrcpyStopSuccessState state) {
    showInfoBar(
      isLong: true,
      title: translatedText(
        key: 'error.scrcpy.unexpectedStop.title',
        translationParams: {'deviceSerial': state.deviceSerial},
      ),
      action: HyperlinkButton(
        child: Text(translatedText(key: 'error.scrcpy.unexpectedStop.action')),
        onPressed: () => showDialog(
          context: context,
          builder: (context) => ConsoleDialog(state: state),
        ),
      ),
      severity: InfoBarSeverity.warning,
    );
  }

  void _showScrcpyNotFoundInfoBar() {
    showInfoBar(
      title: translatedText(key: 'error.scrcpy.notFound.title'),
      content: translatedText(key: 'error.scrcpy.notFound.message'),
      severity: InfoBarSeverity.error,
      isLong: true,
      action: HyperlinkButton(
        child: Text(translatedText(key: 'openSettings')),
        onPressed: () => router.push(AppRoute.settings),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mainItems = _navigationService.getMainItems(context);
    final footerItems = _navigationService.getFooterItems(context);
    final selectedIndex = _navigationService.calculateSelectedIndex(
      context,
      mainItems: mainItems,
      footerItems: footerItems,
    );
    return BlocListener<ScrcpyBloc, ScrcpyState>(
      listener: (context, state) {
        if (state is ScrcpyStartFailedState) {
          if (state.error is ScrcpyNotFoundError) {
            _showScrcpyNotFoundInfoBar();
          } else {
            showInfoBar(
              title: translatedText(key: 'error.scrcpy.failedToStart'),
              content: state.error.toString(),
              severity: InfoBarSeverity.error,
            );
          }
        } else if (state is ScrcpyStopSuccessState && state.stdLines != null) {
          _showUnexpectedStopInfoBar(state);
        }
      },
      child: BlocConsumer<DevicesBloc, DevicesState>(
        listener: (context, state) {
          if (state is InitDeviceTrackingSuccess) {
            _trackDevicesUpdateSubscription?.cancel();
            _trackDevicesUpdateSubscription = _runningProcessManager
                .getStdStream(DevicesBloc.adbTrackDevicesKey)
                ?.listen((_) => _onTrackDevicesUpdateReceived());
            _devicesBloc.add(LoadDevices());
          } else if (state is InitDeviceTrackingFailed) {
            showInfoBar(
              title: translatedText(key: 'error.adb.trackingFailed'),
              content: state.message ?? '',
              severity: InfoBarSeverity.warning,
            );
          }
        },
        builder: (context, state) {
          return NavigationView(
            paneBodyBuilder: (paneItem, _) => LayoutBuilder(
              builder: (context, constraints) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      translatedText(key: 'navigation.${(paneItem!.key! as ValueKey).value}'),
                      style: context.typography.title,
                    ),
                  ),
                  Expanded(child: widget.child),
                  ConsoleSection(maxConsoleViewHeight: constraints.maxHeight * 0.7),
                ],
              ),
            ),
            pane: NavigationPane(
              displayMode: PaneDisplayMode.compact,
              items: mainItems,
              selected: selectedIndex,
              footerItems: footerItems,
            ),
            titleBar: TitleBar(
              isBackButtonVisible: false,
              title: Text(context.translatedText(key: 'appName'), style: typography.bodyStrong),
              endHeader: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ProfileButton(),
                  const SizedBox(width: 8),
                  StartButton(),
                  const SizedBox(width: 8),
                  StopButton(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
