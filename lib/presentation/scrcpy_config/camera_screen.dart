import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:scrcpy_buddy/application/model/scrcpy/scrcpy_arg.dart';
import 'package:scrcpy_buddy/application/profiles_bloc/profiles_bloc.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/widgets/config_combo_box.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/widgets/config_divider.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/widgets/config_item.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/widgets/config_text_box.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/widgets/link_span.dart';
import 'package:scrcpy_buddy/presentation/widgets/app_widgets.dart';
import 'package:scrcpy_buddy/routes.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends AppModuleState<CameraScreen> {
  late final _profilesBloc = context.read<ProfilesBloc>();

  @override
  String get module => 'config.camera';

  final _videoSource = VideoSource();
  final _id = CameraId();
  final _facing = CameraFacing();

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
                if (state.getFor(_videoSource) != 'camera') ...[
                  InfoBar(
                    isLong: true,
                    severity: InfoBarSeverity.warning,
                    title: Text(translatedText(key: 'infoBar.title')),
                    content: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: translatedText(key: 'infoBar.description')),
                          LinkSpan(
                            text: translatedText(key: 'infoBar.button'),
                            onTap: () => context.go(AppRoute.video),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Card(
                  padding: EdgeInsets.zero,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ConfigItem(
                        icon: FluentIcons.number_symbol,
                        cliArgument: _id,
                        child: ConfigTextBox(
                          value: state.getFor(_id),
                          isNumberOnly: true,
                          onChanged: (newId) => _profilesBloc.add(UpdateProfileArgEvent(_id, newId)),
                        ),
                      ),
                      const ConfigDivider(),
                      ConfigItem(
                        icon: WindowsIcons.rotate_camera,
                        cliArgument: _facing,
                        child: ConfigComboBox(state: state, cliArgument: _facing),
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
