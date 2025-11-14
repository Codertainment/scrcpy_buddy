import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrcpy_buddy/application/model/adb/adb_device.dart';
import 'package:scrcpy_buddy/application/model/scrcpy/std_line.dart';
import 'package:scrcpy_buddy/application/scrcpy_bloc/scrcpy_bloc.dart';
import 'package:scrcpy_buddy/presentation/devices/bloc/devices_bloc.dart';
import 'package:scrcpy_buddy/presentation/extension/context_extension.dart';
import 'package:scrcpy_buddy/presentation/home/console_section/widgets/console_view_widget.dart';
import 'package:scrcpy_buddy/presentation/home/console_section/widgets/header_content.dart';
import 'package:scrcpy_buddy/presentation/widgets/app_widgets.dart';
import 'package:scrcpy_buddy/service/running_process_manager.dart';

class ConsoleSection extends StatefulWidget {
  final double maxConsoleViewHeight;

  const ConsoleSection({super.key, this.maxConsoleViewHeight = 400});

  @override
  State<ConsoleSection> createState() => _ConsoleSectionState();
}

class _ConsoleSectionState extends AppModuleState<ConsoleSection> {
  late final _runningProcessManager = context.read<RunningProcessManager>();

  final _consoleViewFocusNode = FocusNode();

  bool _isExpanded = false;
  String? _selectedDeviceSerial;
  Stream<List<StdLine>>? _selectedDeviceStream;
  double _consoleViewHeight = 100;

  @override
  String get module => 'console';

  void _onSelectDevice(AdbDevice device, int index) => setState(() {
    _selectedDeviceSerial = device.serial;
    _isExpanded = true;
    _selectedDeviceStream = _runningProcessManager.getStdStream(_selectedDeviceSerial!);
    _consoleViewFocusNode.requestFocus();
  });

  void _closePanel() => setState(_resetSelectedDeviceState);

  void _resetSelectedDeviceState() {
    _selectedDeviceSerial = null;
    _selectedDeviceStream = null;
    _isExpanded = false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DevicesBloc, DevicesState>(
      builder: (context, devicesState) {
        return BlocBuilder<ScrcpyBloc, ScrcpyState>(
          builder: (context, scrcpyState) {
            if (scrcpyState is! ScrcpyBaseUpdateState || devicesState is! BaseDevicesUpdateState) {
              _selectedDeviceSerial = null;
              _isExpanded = false;
              return SizedBox.shrink();
            } else {
              final devices = devicesState.devices
                  .where((device) => scrcpyState.devices.contains(device.serial))
                  .toList(growable: false);

              if (devices.isEmpty) {
                return SizedBox.shrink();
              }
              if (!devices.map((device) => device.serial).contains(_selectedDeviceSerial)) {
                _resetSelectedDeviceState();
              }
              final headerContent = HeaderContent(
                devices: devices,
                closePanel: _closePanel,
                isExpanded: _isExpanded,
                onSelectDevice: _onSelectDevice,
                selectedDeviceSerial: _selectedDeviceSerial,
              );
              return AnimatedSize(
                duration: context.theme.fastAnimationDuration,
                curve: context.theme.animationCurve,
                child: Container(
                  color: context.theme.resources.solidBackgroundFillColorTertiary.lerpWith(
                    context.theme.brightness.isDark ? Colors.white : Colors.black,
                    0.1,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _isExpanded
                          ? MouseRegion(
                              cursor: SystemMouseCursors.resizeUpDown,
                              child: GestureDetector(
                                onVerticalDragUpdate: (DragUpdateDetails details) {
                                  final newHeight = _consoleViewHeight - details.primaryDelta!;
                                  if (newHeight < widget.maxConsoleViewHeight && newHeight > 50) {
                                    setState(() => _consoleViewHeight = newHeight);
                                  }
                                },
                                child: headerContent,
                              ),
                            )
                          : headerContent,
                      if (_isExpanded) ...[
                        ConsoleViewWidget(
                          focusNode: _consoleViewFocusNode,
                          consoleViewHeight: _consoleViewHeight,
                          selectedDeviceStream: _selectedDeviceStream,
                        ),
                      ],
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
