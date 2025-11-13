import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrcpy_buddy/application/extension/adb_error_extension.dart';
import 'package:scrcpy_buddy/application/model/scrcpy/scrcpy_error.dart';
import 'package:scrcpy_buddy/application/scrcpy_bloc/scrcpy_bloc.dart';
import 'package:scrcpy_buddy/presentation/devices/bloc/devices_bloc.dart';
import 'package:scrcpy_buddy/presentation/devices/device_row.dart';
import 'package:scrcpy_buddy/presentation/devices/widget/devices_header.dart';
import 'package:scrcpy_buddy/presentation/widgets/app_widgets.dart';

class DevicesScreen extends StatefulWidget {
  const DevicesScreen({super.key});

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends AppModuleState<DevicesScreen> {
  late final DevicesBloc _devicesBloc = context.read();

  @override
  String get module => 'devices';

  @override
  void initState() {
    super.initState();
    _devicesBloc.add(LoadDevices());
  }

  void _toggleDeviceSelection(String deviceSerial) => _devicesBloc.add(ToggleDeviceSelection(deviceSerial));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: BlocBuilder<ScrcpyBloc, ScrcpyState>(
        builder: (context, scrcpyState) {
          return BlocBuilder<DevicesBloc, DevicesState>(
            builder: (context, devicesState) {
              return Column(
                children: [
                  CommandBar(
                    primaryItems: [
                      CommandBarButton(
                        onPressed: () => _devicesBloc.add(LoadDevices()),
                        label: Text(translatedText(key: 'refresh')),
                        icon: const Icon(FluentIcons.refresh),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (devicesState is DevicesLoading || devicesState is DevicesInitial) ...[
                    const Center(child: ProgressBar()),
                  ],
                  if (devicesState is DevicesUpdateError) ...[
                    Center(child: Text(devicesState.adbError?.message ?? translatedText(key: 'somethingWentWrong'))),
                  ],
                  if (devicesState is DevicesUpdateSuccess) ...[
                    if (devicesState.devices.isEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          translatedText(key: 'noDevicesFound'),
                          style: FluentTheme.of(context).typography.title,
                        ),
                      ),
                    ] else ...[
                      const DevicesHeader(),
                      Expanded(
                        child: ListView.builder(
                          itemCount: devicesState.devices.length,
                          itemBuilder: (context, index) {
                            final device = devicesState.devices[index];
                            final isDeviceRunning =
                                scrcpyState is ScrcpyBaseUpdateState && scrcpyState.devices.contains(device.serial);
                            return DeviceRow(
                              device: device,
                              shouldRefresh: () => _devicesBloc.add(LoadDevices()),
                              isSelected: devicesState.selectedDeviceSerials.contains(device.serial),
                              isRunning: isDeviceRunning,
                              onSelectionChange: (_) => _toggleDeviceSelection(device.serial),
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ],
              );
            },
          );
        },
      ),
    );
  }
}
