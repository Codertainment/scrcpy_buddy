import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrcpy_buddy/application/model/scrcpy/scrcpy_arg.dart';
import 'package:scrcpy_buddy/application/profiles_bloc/profiles_bloc.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/widgets/config_divider.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/widgets/config_item.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/widgets/config_text_box.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/widgets/config_toggle.dart';
import 'package:scrcpy_buddy/presentation/widgets/app_widgets.dart';

class WindowScreen extends StatefulWidget {
  const WindowScreen({super.key});

  @override
  State<WindowScreen> createState() => _WindowScreenState();
}

class _WindowScreenState extends AppModuleState<WindowScreen> {
  @override
  String get module => 'config.window';

  final _noWindow = NoWindow();
  final _alwaysOnTop = AlwaysOnTop();
  final _title = WindowTitle();
  final _fullscreen = Fullscreen();

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
                    icon: WindowsIcons.hole_punch_off,
                    cliArgument: _noWindow,
                    child: ConfigToggle(state: state, cliArgument: _noWindow),
                  ),
                  const ConfigDivider(),
                  ConfigItem(
                    icon: WindowsIcons.new_window,
                    cliArgument: _alwaysOnTop,
                    child: ConfigToggle(state: state, cliArgument: _alwaysOnTop),
                  ),
                  const ConfigDivider(),
                  ConfigItem(
                    icon: FluentIcons.insert_text_box,
                    hasDefault: true,
                    cliArgument: _title,
                    child: ConfigTextBox(
                      value: state.getFor(_title),
                      onChanged: (newValue) =>
                          context.read<ProfilesBloc>().add(UpdateProfileArgEvent(_title, newValue)),
                    ),
                  ),
                  const ConfigDivider(),
                  ConfigItem(
                    icon: WindowsIcons.full_screen,
                    cliArgument: _fullscreen,
                    child: ConfigToggle(state: state, cliArgument: _fullscreen),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
