import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:scrcpy_buddy/presentation/extension/translation_extension.dart';
import 'package:scrcpy_buddy/routes.dart';

/// Encapsulates navigation pane configuration and route
/// index calculation for the home screen.
class NavigationService {
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

  final _profilesKey = ValueKey('profiles');
  final _settingsKey = ValueKey('settings');

  void _openRoute(BuildContext context, String path) {
    if (GoRouterState.of(context).uri.toString() != path) {
      context.push(path);
    }
  }

  Text _buildPaneItemTitle(BuildContext context, ValueKey<String> key) =>
      Text(context.translatedText(key: 'home.navigation.${key.value}'));

  List<NavigationPaneItem> getMainItems(BuildContext context) => [
    PaneItem(
      key: _devicesKey,
      icon: WindowsIcon(WindowsIcons.companion_app),
      title: _buildPaneItemTitle(context, _devicesKey),
      body: const SizedBox.shrink(),
      onTap: () => _openRoute(context, AppRoute.devices),
    ),
    PaneItemHeader(header: _buildPaneItemTitle(context, ValueKey('scrcpyConfig.sectionTitle'))),
    PaneItem(
      key: _audioKey,
      icon: WindowsIcon(WindowsIcons.audio),
      title: _buildPaneItemTitle(context, _audioKey),
      body: const SizedBox.shrink(),
      onTap: () => _openRoute(context, AppRoute.audio),
    ),
    PaneItem(
      key: _cameraKey,
      icon: WindowsIcon(WindowsIcons.camera),
      title: _buildPaneItemTitle(context, _cameraKey),
      body: const SizedBox.shrink(),
      onTap: () => _openRoute(context, AppRoute.camera),
    ),
    PaneItem(
      key: _controlKey,
      icon: WindowsIcon(WindowsIcons.keyboard_settings),
      title: _buildPaneItemTitle(context, _controlKey),
      body: const SizedBox.shrink(),
      onTap: () => _openRoute(context, AppRoute.control),
    ),
    PaneItem(
      key: _deviceKey,
      icon: WindowsIcon(WindowsIcons.cell_phone),
      title: _buildPaneItemTitle(context, _deviceKey),
      body: const SizedBox.shrink(),
      onTap: () => _openRoute(context, AppRoute.device),
    ),
    PaneItem(
      key: _recordingKey,
      icon: WindowsIcon(WindowsIcons.record),
      title: _buildPaneItemTitle(context, _recordingKey),
      body: const SizedBox.shrink(),
      onTap: () => _openRoute(context, AppRoute.recording),
    ),
    if (Platform.isLinux)
      PaneItem(
        key: _v4l2Key,
        icon: WindowsIcon(FluentIcons.funnel_chart),
        title: _buildPaneItemTitle(context, _v4l2Key),
        body: const SizedBox.shrink(),
        onTap: () => _openRoute(context, AppRoute.v4l2),
      ),
    PaneItem(
      key: _videoKey,
      icon: WindowsIcon(WindowsIcons.video),
      title: _buildPaneItemTitle(context, _videoKey),
      body: const SizedBox.shrink(),
      onTap: () => _openRoute(context, AppRoute.video),
    ),
    PaneItem(
      key: _virtualDisplayKey,
      icon: WindowsIcon(WindowsIcons.t_v_monitor),
      title: _buildPaneItemTitle(context, _virtualDisplayKey),
      body: const SizedBox.shrink(),
      onTap: () => _openRoute(context, AppRoute.virtualDisplay),
    ),
    PaneItem(
      key: _windowKey,
      icon: WindowsIcon(WindowsIcons.hole_punch_portrait_top),
      title: _buildPaneItemTitle(context, _windowKey),
      body: const SizedBox.shrink(),
      onTap: () => _openRoute(context, AppRoute.window),
    ),
  ];

  List<NavigationPaneItem> getFooterItems(BuildContext context) => [
    PaneItemSeparator(),
    PaneItem(
      key: _profilesKey,
      icon: const WindowsIcon(WindowsIcons.guest_user),
      title: _buildPaneItemTitle(context, _profilesKey),
      body: const SizedBox.shrink(),
      onTap: () => _openRoute(context, AppRoute.profiles),
    ),
    PaneItem(
      key: _settingsKey,
      icon: const WindowsIcon(WindowsIcons.settings),
      title: _buildPaneItemTitle(context, _settingsKey),
      body: const SizedBox.shrink(),
      onTap: () => _openRoute(context, AppRoute.settings),
    ),
  ];

  /// Calculates the selected navigation pane index based on
  /// the current route. Accepts pre-built [mainItems] and
  /// [footerItems] to avoid redundant list construction.
  int calculateSelectedIndex(
    BuildContext context, {
    required List<NavigationPaneItem> mainItems,
    required List<NavigationPaneItem> footerItems,
  }) {
    bool isItemMatch(NavigationPaneItem item, String location) => "/${(item.key as ValueKey).value}" == location;

    int findIndex(List<NavigationPaneItem> items, String location) =>
        items.where((item) => item.key != null).toList().indexWhere((item) => isItemMatch(item, location));

    final location = GoRouterState.of(context).uri.toString();
    int indexOriginal = findIndex(mainItems, location);

    if (indexOriginal == -1) {
      int indexFooter = findIndex(footerItems, location);
      if (indexFooter == -1) {
        return 0;
      }
      return mainItems.where((element) => element.key != null).toList().length + indexFooter;
    } else {
      return indexOriginal;
    }
  }
}
