import 'package:fluent_ui/fluent_ui.dart';
import 'package:scrcpy_buddy/application/model/adb/adb_device.dart';
import 'package:scrcpy_buddy/presentation/extension/context_extension.dart';
import 'package:scrcpy_buddy/presentation/home/console_section/widgets/device_button_content.dart';
import 'package:scrcpy_buddy/presentation/widgets/app_widgets.dart';

class HeaderContent extends AppStatelessWidget {
  final List<AdbDevice> devices;
  final String? selectedDeviceSerial;
  final VoidCallback closePanel;
  final bool isExpanded;
  final void Function(AdbDevice device) onSelectDevice;

  const HeaderContent({
    super.key,
    required this.devices,
    this.selectedDeviceSerial,
    required this.closePanel,
    required this.isExpanded,
    required this.onSelectDevice,
  });

  @override
  String get module => 'console';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: isExpanded ? const EdgeInsets.only(top: 12, left: 12, right: 12) : const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(translatedText(context, key: 'title'), style: context.typography.bodyLarge),
          const SizedBox(width: 8),
          Expanded(
            child: SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  final device = devices[index];
                  final isSelected = selectedDeviceSerial == device.serial;
                  final buttonContent = DeviceButtonContent(device: device, isSelected: isSelected);
                  return Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: isSelected
                          ? FilledButton(onPressed: closePanel, child: buttonContent)
                          : Button(onPressed: () => onSelectDevice(device), child: buttonContent),
                    ),
                  );
                },
              ),
            ),
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: IconButton(
              icon: WindowsIcon(isExpanded ? WindowsIcons.chevron_down : WindowsIcons.chevron_up, size: 16),
              onPressed: isExpanded ? closePanel : () => onSelectDevice(devices.first),
            ),
          ),
        ],
      ),
    );
  }
}
