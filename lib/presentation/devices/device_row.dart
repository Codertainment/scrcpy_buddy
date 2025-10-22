import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:scrcpy_buddy/application/extension/adb_device_extension.dart';
import 'package:scrcpy_buddy/application/model/adb/adb_device.dart';
import 'package:scrcpy_buddy/service/adb_service.dart';

class DeviceRow extends StatelessWidget {
  final AdbDevice device;
  final bool selected;
  final ValueChanged<bool> onSelectionChange;

  const DeviceRow({super.key, required this.device, required this.selected, required this.onSelectionChange});

  @override
  Widget build(BuildContext context) {
    final typography = FluentTheme.of(context).typography;
    return ListTile.selectable(
      title: Row(
        children: [
          if (device.metadata != null && device.model != null && device.codename != null) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(device.model ?? "Unknown", style: typography.bodyStrong),
                const SizedBox(height: 4),
                Text(device.codename ?? "Unknown", style: typography.caption),
              ],
            ),
          ],
          const SizedBox(width: 8),
          Icon(connectionMode),
          const Spacer(),
          Text(device.serial, style: typography.body),
          if (device.isUsb) ...[
            const Spacer(),
            Button(
              onPressed: () => context.read<AdbService>().switchDeviceToTcpIp(device.serial),
              child: Row(children: [Icon(WindowsIcons.wifi), const SizedBox(width: 4), Text("To TCP/IP")]),
            ),
          ],
          // Text(device.metadata.toString()),
        ],
      ),
      selectionMode: ListTileSelectionMode.multiple,
      selected: selected,
      onSelectionChange: (selected) {
        debugPrint("selected $selected ${device.serial}");
        onSelectionChange(selected);
      },
    );
  }

  IconData get connectionMode {
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
}
