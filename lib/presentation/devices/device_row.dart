import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:scrcpy_buddy/application/extension/adb_device_extension.dart';
import 'package:scrcpy_buddy/application/model/adb/adb_device.dart';
import 'package:scrcpy_buddy/presentation/extension/context_extension.dart';
import 'package:scrcpy_buddy/presentation/extension/translation_extension.dart';
import 'package:scrcpy_buddy/service/adb_service.dart';

class DeviceRow extends AppStatelessWidget {
  final AdbDevice device;
  final bool selected;
  final ValueChanged<bool> onSelectionChange;

  const DeviceRow({super.key, required this.device, required this.selected, required this.onSelectionChange});

  @override
  String get module => 'devices';

  @override
  Widget build(BuildContext context) {
    return ListTile.selectable(
      title: Row(
        children: [
          if (device.metadata != null && device.model != null && device.codename != null) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(device.model ?? translatedText(context, key: 'unknown'), style: context.typography.bodyStrong),
                const SizedBox(height: 4),
                Text(device.codename ?? translatedText(context, key: 'unknown'), style: context.typography.caption),
              ],
            ),
          ] else if (device.status == AdbDeviceStatus.unauthorized) ...[
            Text(translatedText(context, key: 'deviceState.unauthorized'), style: context.typography.bodyStrong),
          ],
          const SizedBox(width: 8),
          Tooltip(
            message: translatedText(context, key: 'deviceState.$deviceStatusTooltip'),
            child: Icon(deviceStatusIcon),
          ),
          const Spacer(),
          Text(device.serial, style: context.typography.body),
          if (device.isUsb) ...[
            const Spacer(),
            Button(
              onPressed: () => context.read<AdbService>().switchDeviceToTcpIp(device.serial),
              child: Row(
                children: [
                  Icon(WindowsIcons.wifi),
                  const SizedBox(width: 4),
                  Text(translatedText(context, key: 'toNetwork')),
                ],
              ),
            ),
          ],
        ],
      ),
      selectionMode: ListTileSelectionMode.multiple,
      selected: selected,
      onSelectionChange: onSelectionChange,
    );
  }

  IconData get deviceStatusIcon {
    switch (device.status) {
      case AdbDeviceStatus.offline:
        return WindowsIcons.network_offline;
      case AdbDeviceStatus.device:
        if (device.isUsb) {
          return WindowsIcons.usb;
        } else {
          return WindowsIcons.wifi;
        }
      case AdbDeviceStatus.unauthorized:
        return FluentIcons.user_warning;
    }
  }

  String get deviceStatusTooltip {
    switch (device.status) {
      case AdbDeviceStatus.offline:
        return 'offline';
      case AdbDeviceStatus.device:
        if (device.isUsb) {
          return 'usb';
        } else {
          return 'network';
        }
      case AdbDeviceStatus.unauthorized:
        return 'unauthorized';
    }
  }
}
