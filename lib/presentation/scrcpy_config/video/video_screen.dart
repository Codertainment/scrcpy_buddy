import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrcpy_buddy/application/model/scrcpy/scrcpy_arg.dart';
import 'package:scrcpy_buddy/application/profiles_bloc/profiles_bloc.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/video/bit_rate_config.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/widgets/config_divider.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/widgets/config_item.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/widgets/config_text_box.dart';
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
                    label: 'video.noVideo',
                    child: ToggleSwitch(
                      checked: state.getFor(_noVideo) ?? false,
                      onChanged: (checked) => _profilesBloc.add(UpdateProfileArgEvent(_noVideo, checked)),
                    ),
                  ),
                  const ConfigDivider(),
                  ConfigItem(
                    label: 'video.size',
                    child: ConfigTextBox(
                      value: state.getFor(_size),
                      isNumberOnly: true,
                      onChanged: (newValue) => _profilesBloc.add(UpdateProfileArgEvent(_size, newValue)),
                    ),
                  ),
                  const ConfigDivider(),
                  ConfigItem(label: 'video.bitRate', child: BitRateConfig()),
                  const ConfigDivider(),
                  ConfigItem(
                    label: 'video.maxFps',
                    child: ConfigTextBox(
                      value: state.getFor(_maxFps),
                      isNumberOnly: true,
                      onChanged: (newValue) => _profilesBloc.add(UpdateProfileArgEvent(_maxFps, newValue)),
                    ),
                  ),
                  const ConfigDivider(),
                  ConfigItem(
                    label: 'video.codec',
                    child: ComboBox<String>(
                      value: state.getFor(_codec),
                      placeholder: const DropdownPlaceholder(),
                      items: _codec.values!
                          .map((codec) {
                            return ComboBoxItem<String>(value: codec, child: Text(codec));
                          })
                          .toList(growable: false),
                      onChanged: (codec) => _profilesBloc.add(UpdateProfileArgEvent(_codec, codec)),
                    ),
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
