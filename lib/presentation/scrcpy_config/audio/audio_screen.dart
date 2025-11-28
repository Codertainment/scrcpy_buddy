import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrcpy_buddy/application/model/scrcpy/scrcpy_arg.dart';
import 'package:scrcpy_buddy/application/profiles_bloc/profiles_bloc.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/widgets/config_combo_box.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/widgets/config_divider.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/widgets/config_item.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/widgets/config_toggle.dart';
import 'package:scrcpy_buddy/presentation/widgets/app_widgets.dart';

class AudioScreen extends StatefulWidget {
  const AudioScreen({super.key});

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends AppModuleState<AudioScreen> {
  @override
  String get module => 'config.audio';

  final _noAudio = NoAudio();
  final _source = AudioSource();
  final _codec = AudioCodec();

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
                    icon: WindowsIcons.volume_disabled,
                    cliArgument: _noAudio,
                    child: ConfigToggle(state: state, cliArgument: _noAudio),
                  ),
                  const ConfigDivider(),
                  ConfigItem(
                    icon: WindowsIcons.mix_volumes,
                    hasDefault: true,
                    cliArgument: _source,
                    child: ConfigComboBox(state: state, cliArgument: _source),
                  ),
                  const ConfigDivider(),
                  ConfigItem(
                    icon: WindowsIcons.line_display,
                    hasDefault: true,
                    cliArgument: _codec,
                    child: ConfigComboBox(state: state, cliArgument: _codec),
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
