import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrcpy_buddy/application/args_bloc/args_bloc.dart';
import 'package:scrcpy_buddy/application/scrcpy_bloc/scrcpy_bloc.dart';
import 'package:scrcpy_buddy/presentation/devices/bloc/devices_bloc.dart';
import 'package:scrcpy_buddy/presentation/widgets/app_widgets.dart';

class StartButton extends AppStatelessWidget {
  const StartButton({super.key, required this.scrcpyBloc, required this.argsBloc});

  final ScrcpyBloc scrcpyBloc;
  final ArgsBloc argsBloc;

  @override
  String get module => 'home';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArgsBloc, ArgsState>(
      builder: (context, argsState) {
        return BlocBuilder<DevicesBloc, DevicesState>(
          builder: (context, devicesState) {
            final playButtonEnabled =
                argsState is ArgsUpdatedState &&
                devicesState is BaseDevicesUpdateState &&
                devicesState.selectedDeviceSerials.isNotEmpty;
            return FilledButton(
              onPressed: playButtonEnabled ? () => _startScrcpy(context, devicesState) : null,
              child: Row(
                children: [
                  const WindowsIcon(WindowsIcons.play, size: 16),
                  const SizedBox(width: 8),
                  Text(translatedText(context, key: 'start')),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _startScrcpy(BuildContext context, BaseDevicesUpdateState devicesState) {
    for (final deviceSerial in devicesState.selectedDeviceSerials) {
      scrcpyBloc.add(StartScrcpyEvent(deviceSerial: deviceSerial, args: argsBloc.calculateArgsList()));
    }
  }
}
