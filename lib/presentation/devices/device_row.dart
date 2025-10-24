import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:scrcpy_buddy/application/extension/adb_device_extension.dart';
import 'package:scrcpy_buddy/application/extension/adb_error_extension.dart';
import 'package:scrcpy_buddy/application/model/adb/adb_device.dart';
import 'package:scrcpy_buddy/presentation/extension/context_extension.dart';
import 'package:scrcpy_buddy/presentation/extension/translation_extension.dart';
import 'package:scrcpy_buddy/presentation/widgets/icon_text_button.dart';
import 'package:scrcpy_buddy/service/adb_service.dart';

class DeviceRow extends StatefulWidget {
  final AdbDevice device;
  final bool selected;
  final ValueChanged<bool> onSelectionChange;
  final VoidCallback shouldRefresh;

  const DeviceRow({
    super.key,
    required this.device,
    required this.selected,
    required this.onSelectionChange,
    required this.shouldRefresh,
  });

  @override
  State<DeviceRow> createState() => _DeviceRowState();
}

class _DeviceRowState extends AppModuleState<DeviceRow> {
  bool isNetworkSwitchInProgress = false;
  final _toNetworkFlyoutController = FlyoutController();
  final _disconnectFlyoutController = FlyoutController();
  late final _adbService = context.read<AdbService>();

  @override
  String get module => 'devices';

  @override
  Widget build(BuildContext context) {
    return ListTile.selectable(
      title: Row(
        children: [
          /* Device model and codename */
          if (widget.device.metadata != null && widget.device.model != null && widget.device.codename != null) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.device.model ?? translatedText(key: 'unknown'), style: context.typography.bodyStrong),
                const SizedBox(height: 4),
                Text(widget.device.codename ?? translatedText(key: 'unknown'), style: context.typography.caption),
              ],
            ),
          ] else if (widget.device.status == AdbDeviceStatus.unauthorized) ...[
            Text(translatedText(key: 'deviceState.unauthorized'), style: context.typography.bodyStrong),
          ],
          const SizedBox(width: 8),
          /* Connection status icon */
          Tooltip(
            message: translatedText(key: 'deviceState.$deviceStatusTooltip'),
            child: Icon(deviceStatusIcon),
          ),
          const Spacer(),
          /* serial */
          Text(widget.device.serial, style: context.typography.body),
          /* Device actions */
          if (widget.device.isUsb) ...[
            const Spacer(),
            /* Switch USB to network */
            FlyoutTarget(
              controller: _toNetworkFlyoutController,
              child: isNetworkSwitchInProgress
                  ? const ProgressBar()
                  : IconTextButton(
                      onPressed: _switchToNetwork,
                      icon: const Icon(WindowsIcons.wifi),
                      text: translatedText(key: 'toNetwork'),
                    ),
            ),
          ] else if (widget.device.isNetwork || widget.device.status == AdbDeviceStatus.unauthorized) ...[
            const Spacer(),
            /* Disconnect device */
            FlyoutTarget(
              controller: _disconnectFlyoutController,
              child: IconTextButton(
                onPressed: _showDisconnectConfirmationDialog,
                icon: const Icon(WindowsIcons.clear),
                text: translatedText(key: 'disconnect.button'),
              ),
            ),
          ],
        ],
      ),
      selectionMode: ListTileSelectionMode.multiple,
      selected: widget.selected,
      onSelectionChange: widget.onSelectionChange,
    );
  }

  void _showDisconnectConfirmationDialog() async {
    final shouldDisconnect = await showDialog<bool>(
      context: context,
      builder: (context) => ContentDialog(
        title: Text(translatedText(key: 'disconnect.title')),
        content: Text(translatedText(key: 'disconnect.message')),
        actions: [
          Button(
            child: Text(translatedText(key: 'disconnect.confirm')),
            onPressed: () => Navigator.pop(context, true),
          ),
          FilledButton(
            child: Text(context.translatedText(key: 'common.cancel')),
            onPressed: () => Navigator.pop(context, false),
          ),
        ],
      ),
    );
    if (shouldDisconnect == true) {
      final disconnectResult = await _adbService.disconnect(widget.device.serial);
      disconnectResult.mapLeft(
        (error) =>
            _disconnectFlyoutController.showFlyout(builder: (context) => FlyoutContent(child: Text(error.message))),
      );
      widget.shouldRefresh();
    }
  }

  Future<void> _switchToNetwork() async {
    setState(() {
      isNetworkSwitchInProgress = true;
    });
    final switchResult = await _adbService.switchDeviceToTcpIp(widget.device.serial);
    setState(() {
      isNetworkSwitchInProgress = false;
    });
    switchResult.mapLeft(
      (error) => _toNetworkFlyoutController.showFlyout(
        builder: (context) {
          return FlyoutContent(child: Text(error.message));
        },
      ),
    );
    switchResult.map((result) async {
      await _toNetworkFlyoutController.showFlyout(
        builder: (context) {
          return FlyoutContent(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(translatedText(key: 'switchedToNetwork')),
                const SizedBox(height: 8),
                Button(
                  child: Text(context.translatedText(key: 'common.done')),
                  onPressed: () => _toNetworkFlyoutController.close(),
                ),
              ],
            ),
          );
        },
      );
      widget.shouldRefresh();
    });
  }

  IconData get deviceStatusIcon {
    switch (widget.device.status) {
      case AdbDeviceStatus.offline:
        return WindowsIcons.network_offline;
      case AdbDeviceStatus.device:
        if (widget.device.isUsb) {
          return WindowsIcons.usb;
        } else {
          return WindowsIcons.wifi;
        }
      case AdbDeviceStatus.unauthorized:
        return FluentIcons.user_warning;
    }
  }

  String get deviceStatusTooltip {
    switch (widget.device.status) {
      case AdbDeviceStatus.offline:
        return 'offline';
      case AdbDeviceStatus.device:
        if (widget.device.isUsb) {
          return 'usb';
        } else {
          return 'network';
        }
      case AdbDeviceStatus.unauthorized:
        return 'unauthorized';
    }
  }
}
