import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrcpy_buddy/application/profiles_bloc/profiles_bloc.dart';
import 'package:scrcpy_buddy/presentation/extension/context_extension.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/control/widgets/modes_info_bar.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/widgets/config_combo_box.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/widgets/config_divider.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/widgets/config_item.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/widgets/config_text_box.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/widgets/config_toggle.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/widgets/dropdown_placeholder.dart';
import 'package:scrcpy_buddy/presentation/widgets/app_widgets.dart';

import 'package:scrcpy_buddy/application/model/scrcpy/scrcpy_arg.dart';

class ControlScreen extends StatefulWidget {
  const ControlScreen({super.key});

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends AppModuleState<ControlScreen> {
  late final _profilesBloc = context.read<ProfilesBloc>();

  @override
  String get module => 'config.control';

  final _noControl = NoControl();
  final _pushTarget = PushTarget();
  final _keyboardMode = KeyboardMode();
  final _mouseMode = MouseMode();
  final _gamepadMode = GamepadMode();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: BlocBuilder<ProfilesBloc, ProfilesState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ModesInfoBar(),
                const SizedBox(height: 16),
                Card(
                  padding: EdgeInsets.zero,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // General Control Options
                      ConfigItem(
                        icon: WindowsIcons.touch,
                        cliArgument: _noControl,
                        child: ConfigToggle(state: state, cliArgument: _noControl),
                      ),
                      const ConfigDivider(),

                      // Keyboard Options
                      ConfigItem(
                        icon: WindowsIcons.keyboard_settings,
                        hasDefault: true,
                        cliArgument: _keyboardMode,
                        child: ConfigComboBox(state: state, cliArgument: _keyboardMode),
                      ),
                      const ConfigDivider(),

                      // Mouse Options
                      ConfigItem(
                        icon: WindowsIcons.mouse,
                        hasDefault: true,
                        cliArgument: _mouseMode,
                        child: ConfigComboBox(state: state, cliArgument: _mouseMode),
                      ),
                      const ConfigDivider(),

                      // Gamepad Options
                      ConfigItem(
                        icon: WindowsIcons.game,
                        hasDefault: true,
                        cliArgument: _gamepadMode,
                        child: ConfigComboBox(state: state, cliArgument: _gamepadMode),
                      ),
                      const ConfigDivider(),

                      // File Drop Target
                      ConfigItem(
                        icon: WindowsIcons.download,
                        hasDefault: true,
                        cliArgument: _pushTarget,
                        child: ConfigTextBox(
                          maxWidth: context.windowSize.width * 0.25,
                          value: state.getFor(_pushTarget),
                          onChanged: (newValue) => _profilesBloc.add(UpdateProfileArgEvent(_pushTarget, newValue)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
