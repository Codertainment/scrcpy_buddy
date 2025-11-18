import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrcpy_buddy/application/scrcpy_bloc/scrcpy_bloc.dart';
import 'package:scrcpy_buddy/presentation/devices/bloc/devices_bloc.dart';
import 'package:scrcpy_buddy/presentation/extension/context_extension.dart';
import 'package:scrcpy_buddy/presentation/widgets/app_widgets.dart';
import 'package:fluent_ui/fluent_ui.dart';

class StopButton extends AppStatelessWidget {
  const StopButton({super.key});

  @override
  String get module => 'home';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScrcpyBloc, ScrcpyState>(
      builder: (context, scrcpyState) {
        return BlocBuilder<DevicesBloc, DevicesState>(
          builder: (context, devicesState) {
            final isEnabled =
                scrcpyState is ScrcpyBaseUpdateState &&
                devicesState is DevicesBaseUpdateState &&
                devicesState.selectedDeviceSerials.intersection(scrcpyState.devices).isNotEmpty;
            return FilledButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateColor.resolveWith((states) {
                  if (states.isDisabled) {
                    return context.theme.resources.accentFillColorDisabled;
                  } else if (states.isPressed) {
                    return Colors.red.tertiaryBrushFor(context.theme.brightness);
                  } else if (states.isHovered) {
                    return Colors.red.secondaryBrushFor(context.theme.brightness);
                  } else {
                    return Colors.red.defaultBrushFor(context.theme.brightness);
                  }
                }),
              ),
              onPressed: isEnabled ? () => _stopScrcpy(context, devicesState, scrcpyState) : null,
              child: Row(
                children: [
                  WindowsIcon(WindowsIcons.stop, size: 16),
                  const SizedBox(width: 4),
                  Text(translatedText(context, key: 'stop')),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _stopScrcpy(BuildContext context, DevicesBaseUpdateState devicesState, ScrcpyBaseUpdateState scrcpyState) {
    final scrcpyBloc = context.read<ScrcpyBloc>();
    devicesState.selectedDeviceSerials
        .intersection(scrcpyState.devices)
        .forEach((serial) => scrcpyBloc.add(StopScrcpyEvent(deviceSerial: serial)));
  }
}
