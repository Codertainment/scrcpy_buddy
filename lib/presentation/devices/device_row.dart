import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:scrcpy_buddy/application/extension/adb_device_extension.dart';
import 'package:scrcpy_buddy/application/extension/adb_error_extension.dart';
import 'package:scrcpy_buddy/application/model/adb/adb_device.dart';
import 'package:scrcpy_buddy/presentation/extension/context_extension.dart';
import 'package:scrcpy_buddy/presentation/extension/translation_extension.dart';
import 'package:scrcpy_buddy/presentation/widgets/app_widgets.dart';
import 'package:scrcpy_buddy/presentation/widgets/dialogs.dart';
import 'package:scrcpy_buddy/service/adb_service.dart';

class DeviceRow extends StatefulWidget {
  final AdbDevice device;
  final bool isSelected;
  final ValueChanged<bool> onSelectionChange;
  final VoidCallback shouldRefresh;
  final bool isRunning;

  const DeviceRow({
    super.key,
    required this.device,
    required this.isSelected,
    this.isRunning = false,
    required this.onSelectionChange,
    required this.shouldRefresh,
  });

  @override
  State<DeviceRow> createState() => _DeviceRowState();
}

class _DeviceRowState extends AppModuleState<DeviceRow> with SingleTickerProviderStateMixin {
  bool _isNetworkSwitchInProgress = false;
  late final _adbService = context.read<AdbService>();

  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  final _commandBarKey = GlobalKey<CommandBarState>();

  @override
  String get module => 'devices';

  @override
  void didUpdateWidget(covariant DeviceRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRunning != oldWidget.isRunning) {
      if (widget.isRunning) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _colorAnimation = ColorTween(
      begin: Colors.successPrimaryColor,
      end: Colors.successPrimaryColor.withAlpha(100),
    ).animate(_controller);
  }

  bool get canBeSelected => widget.device.status == AdbDeviceStatus.device;

  void _showDisconnectConfirmationDialog() async {
    await _commandBarKey.currentState?.toggleSecondaryMenu();
    final shouldDisconnect = await showDangerActionConfirmationDialog(
      context,
      titleKey: 'devices.disconnect.title',
      messageKey: 'devices.disconnect.message',
      actionKey: 'devices.disconnect.confirm',
    );
    if (shouldDisconnect == true) {
      final disconnectResult = await _adbService.disconnect(widget.device.serial);
      disconnectResult.mapLeft((error) => showInfoBar(title: error.message, severity: InfoBarSeverity.error));
      disconnectResult.map(
        (_) => showInfoBar(
          title: translatedText(key: 'disconnect.done'),
          severity: InfoBarSeverity.success,
        ),
      );
      widget.shouldRefresh();
    }
  }

  Future<void> _switchToNetwork() async {
    setState(() {
      _isNetworkSwitchInProgress = true;
    });
    final switchResult = await _adbService.switchDeviceToTcpIp(widget.device.serial);
    setState(() {
      _isNetworkSwitchInProgress = false;
    });
    switchResult.mapLeft((error) => showInfoBar(title: error.message, severity: InfoBarSeverity.error));
    switchResult.map((result) async {
      showInfoBar(
        title: translatedText(key: 'switchedToNetwork'),
        severity: InfoBarSeverity.success,
      );
      await Future.delayed(Duration(milliseconds: 300));
      widget.shouldRefresh();
      /* refresh again */
      await Future.delayed(Duration(milliseconds: 500), () => widget.shouldRefresh());
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile.selectable(
      selectionMode: ListTileSelectionMode.multiple,
      selected: widget.isSelected,
      onSelectionChange: canBeSelected ? widget.onSelectionChange : null,
      title: Row(
        children: [
          /* Device model and codename */
          Expanded(
            flex: 2,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.device.metadata != null &&
                    widget.device.model != null &&
                    widget.device.codename != null) ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.device.model ?? translatedText(key: 'unknown'), style: context.typography.bodyStrong),
                      const SizedBox(height: 4),
                      Text(widget.device.codename ?? translatedText(key: 'unknown'), style: context.typography.caption),
                    ],
                  ),
                ],
                if (widget.isRunning) ...[
                  const SizedBox(width: 8),
                  // TODO: Change this later to IconButton to allow opening the console out view
                  AnimatedBuilder(
                    animation: _colorAnimation,
                    builder: (_, _) => WindowsIcon(WindowsIcons.circle_fill, color: _colorAnimation.value, size: 16),
                  ),
                ],
              ],
            ),
          ),
          /* status */
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Icon(widget.device.statusIcon),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(context.translatedText(key: widget.device.statusText), style: typography.body),
                ),
              ],
            ),
          ),
          /* serial */
          Expanded(
            flex: 3,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Tooltip(
                  message: translatedText(key: 'copy'),
                  child: IconButton(
                    icon: WindowsIcon(WindowsIcons.copy),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: widget.device.serial));
                      showInfoBar(
                        title: translatedText(key: 'serialCopied'),
                        severity: InfoBarSeverity.success,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(child: Text(widget.device.serial, style: context.typography.body)),
              ],
            ),
          ),
          /* actions */
          Expanded(
            flex: 1,
            child: _isNetworkSwitchInProgress
                ? ProgressBar()
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      DropDownButton(
                        items: [
                          if (widget.device.isUsb) ...[
                            MenuFlyoutItem(
                              onPressed: _switchToNetwork,
                              leading: const Icon(WindowsIcons.wifi),
                              text: Text(translatedText(key: 'toNetwork')),
                            ),
                          ] else if (widget.device.isNetwork ||
                              widget.device.status == AdbDeviceStatus.unauthorized) ...[
                            /* Disconnect device */
                            MenuFlyoutItem(
                              onPressed: _showDisconnectConfirmationDialog,
                              leading: const Icon(WindowsIcons.clear),
                              text: Text(translatedText(key: 'disconnect.button')),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
