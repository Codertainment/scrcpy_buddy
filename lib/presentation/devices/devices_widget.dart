import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrcpy_buddy/presentation/devices/device_row.dart';

import 'cubit/devices_cubit.dart';

class DevicesScreen extends StatelessWidget {
  const DevicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DevicesCubit>(create: (context) => DevicesCubit(context.read()), child: DevicesPage());
  }
}

class DevicesPage extends StatefulWidget {
  const DevicesPage({super.key});

  @override
  State<DevicesPage> createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  late final DevicesCubit cubit = context.read();
  final List<String> selectedDevices = [];

  @override
  void initState() {
    super.initState();
    cubit.loadDevices();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: BlocBuilder<DevicesCubit, DevicesState>(
        builder: (context, state) {
          return Column(
            children: [
              CommandBar(
                primaryItems: [
                  CommandBarButton(
                    onPressed: () => cubit.loadDevices(),
                    label: Text('Refresh'),
                    icon: Icon(WindowsIcons.refresh),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (state is DevicesLoading || state is DevicesInitial) ...[Center(child: ProgressBar())],
              if (state is DevicesLoadFailure) ...[Center(child: Text(state.message ?? 'Something went wrong'))],
              if (state is DevicesLoadSuccess) ...[
                Expanded(
                  child: ListView.builder(
                    itemCount: state.devices.length,
                    itemBuilder: (context, index) {
                      final device = state.devices[index];
                      return DeviceRow(
                        device: device,
                        selected: selectedDevices.contains(device.serial),
                        onSelectionChange: (selected) {
                          debugPrint("selected $selected ${device.serial}");
                          setState(() {
                            if (selected) {
                              selectedDevices.add(device.serial);
                            } else {
                              selectedDevices.remove(device.serial);
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
