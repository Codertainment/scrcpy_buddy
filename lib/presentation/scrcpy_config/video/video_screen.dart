import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrcpy_buddy/application/model/scrcpy/scrcpy_arg.dart';
import 'package:scrcpy_buddy/application/profiles_bloc/profiles_bloc.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/video/bit_rate_config.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/widgets/config_combo_box.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/widgets/config_divider.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/widgets/config_item.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/widgets/config_text_box.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/widgets/config_toggle.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/widgets/dropdown_placeholder.dart';
import 'package:scrcpy_buddy/presentation/widgets/app_widgets.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends AppModuleState<VideoScreen> {
  late final _profilesBloc = context.read<ProfilesBloc>();
  final _noVideo = NoVideo();
  final _size = VideoSize();
  final _maxFps = MaxFps();
  final _codec = VideoCodec();

  @override
  String get module => 'config.video';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: BlocBuilder<ProfilesBloc, ProfilesState>(
        buildWhen: (_, _) => true,
        builder: (context, state) {
          return SingleChildScrollView(
            child: Card(
              padding: EdgeInsets.zero,
              child: Column(
                mainAxisSize: .min,
                crossAxisAlignment: .stretch,
                children: [
                  ConfigItem(
                    icon: FluentIcons.video_off2,
                    cliArgument: _noVideo,
                    child: ConfigToggle(state: state, cliArgument: _noVideo),
                  ),
                  const ConfigDivider(),
                  ConfigItem(
                    icon: FluentIcons.image_pixel,
                    hasDefault: true,
                    cliArgument: _size,
                    child: ConfigTextBox(
                      value: state.getFor(_size),
                      isNumberOnly: true,
                      onChanged: (newValue) => _profilesBloc.add(UpdateProfileArgEvent(_size, newValue)),
                    ),
                  ),
                  const ConfigDivider(),
                  ConfigItem(
                    icon: FluentIcons.rate,
                    hasDefault: true,
                    cliArgument: VideoBitRate(),
                    child: BitRateConfig(),
                  ),
                  const ConfigDivider(),
                  ConfigItem(
                    icon: WindowsIcons.speed_medium,
                    cliArgument: _maxFps,
                    child: ConfigTextBox(
                      value: state.getFor(_maxFps),
                      isNumberOnly: true,
                      onChanged: (newValue) => _profilesBloc.add(UpdateProfileArgEvent(_maxFps, newValue)),
                    ),
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
