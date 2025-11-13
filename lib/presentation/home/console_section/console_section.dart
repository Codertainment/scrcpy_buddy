import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrcpy_buddy/application/extension/adb_device_extension.dart';
import 'package:scrcpy_buddy/application/model/adb/adb_device.dart';
import 'package:scrcpy_buddy/application/scrcpy_bloc/scrcpy_bloc.dart';
import 'package:scrcpy_buddy/presentation/devices/bloc/devices_bloc.dart';
import 'package:scrcpy_buddy/presentation/extension/context_extension.dart';
import 'package:scrcpy_buddy/presentation/extension/translation_extension.dart';
import 'package:scrcpy_buddy/presentation/widgets/app_widgets.dart';

class ConsoleSection extends StatefulWidget {
  const ConsoleSection({super.key});

  @override
  State<ConsoleSection> createState() => _ConsoleSectionState();
}

class _ConsoleSectionState extends AppModuleState<ConsoleSection> {
  int _selectedIndex = -1;
  bool _isExpanded = false;
  String? _selectedDeviceSerial;

  @override
  String get module => 'console';

  void _selectDevice(AdbDevice device, int index) => setState(() {
    _selectedIndex = index;
    _selectedDeviceSerial = device.serial;
    _isExpanded = true;
  });

  void _closePanel() => setState(() {
    _selectedIndex = -1;
    _isExpanded = false;
  });

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
    final brightness = theme.brightness;

    return BlocBuilder<DevicesBloc, DevicesState>(
      builder: (context, devicesState) {
        return BlocBuilder<ScrcpyBloc, ScrcpyState>(
          builder: (context, scrcpyState) {
            if (scrcpyState is! ScrcpyBaseUpdateState || devicesState is! BaseDevicesUpdateState) {
              return SizedBox.shrink();
            } else {
              final devices = devicesState.devices
                  .where((device) => scrcpyState.devices.contains(device.serial))
                  .toList(growable: false);
              if (devices.isEmpty) {
                return SizedBox.shrink();
              }
              return AnimatedSize(
                duration: theme.fastAnimationDuration,
                curve: theme.animationCurve,
                child: Container(
                  padding: EdgeInsets.all(12),
                  color: theme.resources.subtleFillColorSecondary,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(translatedText(key: 'title'), style: typography.bodyLarge),
                          const SizedBox(width: 8),
                          Expanded(
                            child: SizedBox(
                              height: 40,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: devices.length,
                                itemBuilder: (context, index) {
                                  final device = devices[index];
                                  final isSelected = _selectedIndex == index;
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: isSelected
                                        ? FilledButton(
                                            onPressed: _closePanel,
                                            child: _DeviceButtonContent(device: device, isSelected: isSelected),
                                          )
                                        : Button(
                                            onPressed: () => _selectDevice(device, index),
                                            child: _DeviceButtonContent(device: device, isSelected: isSelected),
                                          ),
                                  );
                                },
                              ),
                            ),
                          ),
                          if (_isExpanded) ...{
                            IconButton(icon: WindowsIcon(WindowsIcons.chevron_down), onPressed: _closePanel),
                          },
                        ],
                      ),
                      if (_isExpanded) ...[const SizedBox(height: 12), Container(color: Colors.purple, height: 100)],
                    ],
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }
}

class _DeviceButtonContent extends StatelessWidget {
  final AdbDevice device;
  final bool isSelected;

  const _DeviceButtonContent({required this.device, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
    final foregroundColor = isSelected
        ? theme.resources.textOnAccentFillColorPrimary
        : ButtonThemeData.buttonForegroundColor(context, {WidgetState.focused});
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Tooltip(
          message: context.translatedText(key: device.statusText),
          child: Icon(device.statusIcon, color: foregroundColor),
        ),
        const SizedBox(width: 8),
        Text(device.model ?? 'unknown', style: context.typography.body?.copyWith(color: foregroundColor)),
        Text(' (${device.codename ?? 'unknown'})', style: context.typography.caption?.copyWith(color: foregroundColor)),
      ],
    );
  }
}
