import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrcpy_buddy/application/model/scrcpy/scrcpy_arg.dart';
import 'package:scrcpy_buddy/application/profiles_bloc/profiles_bloc.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/device/start_app_config.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/widgets/config_divider.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/widgets/config_item.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/widgets/config_toggle.dart';
import 'package:scrcpy_buddy/presentation/widgets/app_widgets.dart';

class DeviceScreen extends StatefulWidget {
  const DeviceScreen({super.key});

  @override
  State<DeviceScreen> createState() => _DeviceScreenState();
}

class _DeviceScreenState extends AppModuleState<DeviceScreen> {
  @override
  String get module => 'config.device';

  final _stayAwake = StayAwake();
  final _turnScreenOff = TurnScreenOff();
  final _showTouches = ShowTouches();
  final _startApp = StartApp();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: BlocBuilder<ProfilesBloc, ProfilesState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Card(
              padding: EdgeInsets.zero,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ConfigItem(
                    icon: WindowsIcons.red_eye,
                    cliArgument: _stayAwake,
                    child: ConfigToggle(state: state, cliArgument: _stayAwake),
                  ),
                  const ConfigDivider(),
                  ConfigItem(
                    icon: WindowsIcons.disconnect_display,
                    cliArgument: _turnScreenOff,
                    child: ConfigToggle(state: state, cliArgument: _turnScreenOff),
                  ),
                  const ConfigDivider(),
                  ConfigItem(
                    icon: WindowsIcons.touch,
                    cliArgument: _showTouches,
                    child: ConfigToggle(state: state, cliArgument: _showTouches),
                  ),
                  const ConfigDivider(),
                  ConfigItem(icon: WindowsIcons.app_icon_default_add, cliArgument: _startApp, child: StartAppConfig()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
