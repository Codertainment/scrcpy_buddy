import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrcpy_buddy/application/args_bloc/args_bloc.dart';
import 'package:scrcpy_buddy/application/scrcpy_bloc/scrcpy_bloc.dart';
import 'package:scrcpy_buddy/presentation/devices/bloc/devices_bloc.dart';
import 'package:scrcpy_buddy/presentation/widgets/app_widgets.dart';

class StartButton extends AppStatelessWidget {
  const StartButton({super.key});

  @override
  String get module => 'home';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScrcpyBloc, ScrcpyState>(
      builder: (context, scrcpyState) {
        return BlocBuilder<ArgsBloc, ArgsState>(
          builder: (context, argsState) {
            return BlocBuilder<DevicesBloc, DevicesState>(
              builder: (context, devicesState) {
                final isEnabled =
                    argsState is ArgsUpdatedState &&
                    devicesState is DevicesBaseUpdateState &&
                    (scrcpyState is ScrcpyInitial && devicesState.selectedDeviceSerials.isNotEmpty ||
                        scrcpyState is ScrcpyBaseUpdateState &&
                            devicesState.selectedDeviceSerials.difference(scrcpyState.devices).isNotEmpty);
                return LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 150) {
                      return _IconButton(
                        isEnabled: isEnabled,
                        onPressed: () => _startScrcpy(context, devicesState as DevicesBaseUpdateState, scrcpyState),
                      );
                    } else {
                      return _FilledButton(
                        isEnabled: isEnabled,
                        onPressed: () => _startScrcpy(context, devicesState as DevicesBaseUpdateState, scrcpyState),
                      );
                    }
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  void _startScrcpy(BuildContext context, DevicesBaseUpdateState devicesState, ScrcpyState scrcpyState) {
    final scrcpyBloc = context.read<ScrcpyBloc>();
    final argsBloc = context.read<ArgsBloc>();
    final Set<String> devicesToStart = {};
    if (scrcpyState is ScrcpyInitial) {
      devicesToStart.addAll(devicesState.selectedDeviceSerials);
    } else if (scrcpyState is ScrcpyBaseUpdateState) {
      devicesToStart.addAll(devicesState.selectedDeviceSerials.difference(scrcpyState.devices));
    }
    for (final deviceSerial in devicesToStart) {
      scrcpyBloc.add(StartScrcpyEvent(deviceSerial: deviceSerial, args: argsBloc.calculateArgsList()));
    }
  }
}

class _FilledButton extends AppStatelessWidget {
  final bool isEnabled;
  final VoidCallback onPressed;

  const _FilledButton({required this.isEnabled, required this.onPressed});

  @override
  String get module => 'home';

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: isEnabled ? onPressed : null,
      child: Row(
        children: [
          const WindowsIcon(WindowsIcons.play, size: 16),
          const SizedBox(width: 4),
          Text(translatedText(context, key: 'start')),
        ],
      ),
    );
  }
}

class _IconButton extends AppStatelessWidget {
  final bool isEnabled;
  final VoidCallback onPressed;

  const _IconButton({required this.isEnabled, required this.onPressed});

  @override
  String get module => 'home';

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: translatedText(context, key: 'start'),
      child: IconButton(icon: const WindowsIcon(WindowsIcons.play, size: 16), onPressed: isEnabled ? onPressed : null),
    );
  }
}
