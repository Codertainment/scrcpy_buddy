import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrcpy_buddy/application/extension/adb_device_extension.dart';
import 'package:scrcpy_buddy/application/model/adb/adb_device.dart';
import 'package:scrcpy_buddy/application/scrcpy_bloc/scrcpy_bloc.dart';
import 'package:scrcpy_buddy/presentation/extension/context_extension.dart';
import 'package:scrcpy_buddy/presentation/extension/translation_extension.dart';

class DeviceButtonContent extends StatefulWidget {
  final AdbDevice device;
  final bool isSelected;

  const DeviceButtonContent({super.key, required this.device, required this.isSelected});

  @override
  State<DeviceButtonContent> createState() => _DeviceButtonContentState();
}

class _DeviceButtonContentState extends State<DeviceButtonContent> {
  final _flyoutController = FlyoutController();

  @override
  Widget build(BuildContext context) {
    final foregroundColor = widget.isSelected
        ? context.theme.resources.textOnAccentFillColorPrimary
        : ButtonThemeData.buttonForegroundColor(context, {WidgetState.focused});
    return FlyoutTarget(
      controller: _flyoutController,
      child: GestureDetector(
        onSecondaryTap: () {
          _flyoutController.showFlyout(
            builder: (context) {
              return MenuFlyout(
                items: [
                  MenuFlyoutItem(
                    leading: Icon(WindowsIcons.stop),
                    text: Text(context.translatedText(key: 'devices.stop')),
                    onPressed: () =>
                        context.read<ScrcpyBloc>().add(StopScrcpyEvent(deviceSerial: widget.device.serial)),
                  ),
                ],
              );
            },
          );
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Tooltip(
              message: context.translatedText(key: widget.device.statusText),
              child: Icon(widget.device.statusIcon, color: foregroundColor),
            ),
            const SizedBox(width: 8),
            Text(widget.device.model ?? 'unknown', style: context.typography.body?.copyWith(color: foregroundColor)),
            Text(
              ' (${widget.device.codename ?? 'unknown'})',
              style: context.typography.caption?.copyWith(color: foregroundColor),
            ),
          ],
        ),
      ),
    );
  }
}
