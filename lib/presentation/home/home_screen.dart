import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:scrcpy_buddy/application/model/scrcpy/scrcpy_error.dart';
import 'package:scrcpy_buddy/application/profiles_bloc/profiles_bloc.dart';
import 'package:scrcpy_buddy/application/scrcpy_bloc/scrcpy_bloc.dart';
import 'package:scrcpy_buddy/presentation/extension/context_extension.dart';
import 'package:scrcpy_buddy/presentation/extension/translation_extension.dart';
import 'package:scrcpy_buddy/presentation/home/console_section/console_section.dart';
import 'package:scrcpy_buddy/presentation/home/widgets/profile_button.dart';
import 'package:scrcpy_buddy/presentation/home/widgets/start_button.dart';
import 'package:scrcpy_buddy/presentation/home/widgets/stop_button.dart';
import 'package:scrcpy_buddy/presentation/widgets/app_widgets.dart';
import 'package:scrcpy_buddy/routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.child});

  final Widget child;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends AppModuleState<HomeScreen> {
  late final _profilesBloc = context.read<ProfilesBloc>();

  final _devicesKey = ValueKey('devices');

  final _audioKey = ValueKey('scrcpyConfig.audio');
  final _cameraKey = ValueKey('scrcpyConfig.camera');
  final _controlKey = ValueKey('scrcpyConfig.control');
  final _deviceKey = ValueKey('scrcpyConfig.device');
  final _recordingKey = ValueKey('scrcpyConfig.recording');
  final _v4l2Key = ValueKey('scrcpyConfig.v4l2');
  final _videoKey = ValueKey('scrcpyConfig.video');
  final _virtualDisplayKey = ValueKey('scrcpyConfig.virtualDisplay');

  final _windowKey = ValueKey('scrcpyConfig.window');

  final _settingsKey = ValueKey('settings');

  @override
  void initState() {
    super.initState();
    _profilesBloc.add(InitializeProfilesEvent());
  }

  @override
  String get module => 'home';

  void _openRoute(String path) {
    if (GoRouterState.of(context).uri.toString() != path) {
      context.push(path);
    }
  }

  Text _buildPaneItemTitle(BuildContext context, ValueKey<String> key) =>
      Text(context.translatedText(key: 'home.navigation.${key.value}'));

  List<NavigationPaneItem> _getMainItems(BuildContext context) => [
    PaneItem(
      key: _devicesKey,
      icon: WindowsIcon(WindowsIcons.companion_app),
      title: _buildPaneItemTitle(context, _devicesKey),
      body: const SizedBox.shrink(),
      onTap: () => _openRoute(AppRoute.devices),
    ),
    PaneItemHeader(header: _buildPaneItemTitle(context, ValueKey('scrcpyConfig.sectionTitle'))),
    PaneItem(
      key: _audioKey,
      icon: WindowsIcon(WindowsIcons.audio),
      title: _buildPaneItemTitle(context, _audioKey),
      body: const SizedBox.shrink(),
      onTap: () => _openRoute(AppRoute.audio),
    ),
    PaneItem(
      key: _cameraKey,
      icon: WindowsIcon(WindowsIcons.camera),
      title: _buildPaneItemTitle(context, _cameraKey),
      body: const SizedBox.shrink(),
      onTap: () => _openRoute(AppRoute.camera),
    ),
    PaneItem(
      key: _controlKey,
      icon: WindowsIcon(WindowsIcons.keyboard_settings),
      title: _buildPaneItemTitle(context, _controlKey),
      body: const SizedBox.shrink(),
      onTap: () => _openRoute(AppRoute.control),
    ),
    PaneItem(
      key: _deviceKey,
      icon: WindowsIcon(WindowsIcons.cell_phone),
      title: _buildPaneItemTitle(context, _deviceKey),
      body: const SizedBox.shrink(),
      onTap: () => _openRoute(AppRoute.device),
    ),
    PaneItem(
      key: _recordingKey,
      icon: WindowsIcon(WindowsIcons.record),
      title: _buildPaneItemTitle(context, _recordingKey),
      body: const SizedBox.shrink(),
      onTap: () => _openRoute(AppRoute.recording),
    ),
    if (Platform.isLinux)
      PaneItem(
        key: _v4l2Key,
        icon: WindowsIcon(FluentIcons.funnel_chart),
        title: _buildPaneItemTitle(context, _v4l2Key),
        body: const SizedBox.shrink(),
        onTap: () => _openRoute(AppRoute.v4l2),
      ),
    PaneItem(
      key: _videoKey,
      icon: WindowsIcon(WindowsIcons.video),
      title: _buildPaneItemTitle(context, _videoKey),
      body: const SizedBox.shrink(),
      onTap: () => _openRoute(AppRoute.video),
    ),
    PaneItem(
      key: _virtualDisplayKey,
      icon: WindowsIcon(WindowsIcons.t_v_monitor),
      title: _buildPaneItemTitle(context, _virtualDisplayKey),
      body: const SizedBox.shrink(),
      onTap: () => _openRoute(AppRoute.virtualDisplay),
    ),
    PaneItem(
      key: _windowKey,
      icon: WindowsIcon(WindowsIcons.hole_punch_portrait_top),
      title: _buildPaneItemTitle(context, _windowKey),
      body: const SizedBox.shrink(),
      onTap: () => _openRoute(AppRoute.window),
    ),
  ];

  List<NavigationPaneItem> _getFooterItems(BuildContext context) => [
    PaneItem(
      key: _settingsKey,
      icon: const WindowsIcon(WindowsIcons.settings),
      title: _buildPaneItemTitle(context, _settingsKey),
      body: const SizedBox.shrink(),
      onTap: () => _openRoute(AppRoute.settings),
    ),
  ];

  int _calculateSelectedIndex(BuildContext context) {
    bool isItemMatch(NavigationPaneItem item, String location) => "/${(item.key as ValueKey).value}" == location;

    int findIndex(List<NavigationPaneItem> items, String location) =>
        items.where((item) => item.key != null).toList().indexWhere((item) => isItemMatch(item, location));

    final location = GoRouterState.of(context).uri.toString();
    final mainItems = _getMainItems(context);
    int indexOriginal = findIndex(mainItems, location);

    if (indexOriginal == -1) {
      int indexFooter = findIndex(_getFooterItems(context), location);
      if (indexFooter == -1) {
        return 0;
      }
      return mainItems.where((element) => element.key != null).toList().length + indexFooter;
    } else {
      return indexOriginal;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mainItems = _getMainItems(context);
    final footerItems = _getFooterItems(context);
    final selectedIndex = _calculateSelectedIndex(context);
    return BlocListener<ScrcpyBloc, ScrcpyState>(
      listener: (context, state) {
        if (state is ScrcpyStartFailedState) {
          if (state.error is ScrcpyNotFoundError) {
            showInfoBar(
              title: translatedText(key: 'error.scrcpy.notFound.title'),
              content: translatedText(key: 'error.scrcpy.notFound.message'),
              severity: InfoBarSeverity.error,
              action: HyperlinkButton(
                child: Text(translatedText(key: 'goToSettings')),
                onPressed: () => router.push(AppRoute.settings),
              ),
            );
          } else {
            showInfoBar(
              title: translatedText(key: 'error.scrcpy.failedToStart'),
              content: state.error.toString(),
              severity: InfoBarSeverity.error,
            );
          }
        }
      },
      child: NavigationView(
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
        appBar: NavigationAppBar(
          title: Text('scrcpy buddy', style: typography.bodyStrong),
          actions: Padding(
            padding: const EdgeInsets.only(top: 12, right: 16),
            child: Row(
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
        ),
      ),
    );
  }
}
