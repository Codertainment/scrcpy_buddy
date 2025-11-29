import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrcpy_buddy/application/profiles_bloc/profiles_bloc.dart';
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
        return BlocBuilder<ProfilesBloc, ProfilesState>(
          builder: (context, profilesState) {
            return BlocBuilder<DevicesBloc, DevicesState>(
              builder: (context, devicesState) {
                final playButtonEnabled =
                    devicesState is DevicesBaseUpdateState &&
                    (scrcpyState is ScrcpyInitial && devicesState.selectedDeviceSerials.isNotEmpty ||
                        scrcpyState is ScrcpyBaseUpdateState &&
                            devicesState.selectedDeviceSerials.difference(scrcpyState.devices).isNotEmpty);
                return FilledButton(
                  onPressed: playButtonEnabled ? () => _startScrcpy(context, devicesState, scrcpyState) : null,
                  child: Row(
                    children: [
                      const WindowsIcon(WindowsIcons.play, size: 16),
                      const SizedBox(width: 4),
                      Text(translatedText(context, key: 'start')),
                    ],
                  ),
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
    final profilesBloc = context.read<ProfilesBloc>();
    final Set<String> devicesToStart = {};
    if (scrcpyState is ScrcpyInitial) {
      devicesToStart.addAll(devicesState.selectedDeviceSerials);
    } else if (scrcpyState is ScrcpyBaseUpdateState) {
      devicesToStart.addAll(devicesState.selectedDeviceSerials.difference(scrcpyState.devices));
    }
    final args = profilesBloc.state.toArgsList();
    if (kDebugMode) {
      debugPrint("args: $args");
    }
    for (final deviceSerial in devicesToStart) {
      scrcpyBloc.add(StartScrcpyEvent(deviceSerial: deviceSerial, args: args));
    }
  }
}
