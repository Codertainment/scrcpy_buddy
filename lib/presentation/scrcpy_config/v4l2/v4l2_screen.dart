import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrcpy_buddy/application/model/scrcpy/scrcpy_arg.dart';
import 'package:scrcpy_buddy/application/profiles_bloc/profiles_bloc.dart';
import 'package:scrcpy_buddy/main.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/widgets/config_item.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/widgets/config_text_box.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/widgets/link_span.dart';
import 'package:scrcpy_buddy/presentation/widgets/app_widgets.dart';
import 'package:url_launcher/url_launcher_string.dart';

class V4l2Screen extends StatefulWidget {
  const V4l2Screen({super.key});

  @override
  State<V4l2Screen> createState() => _V4l2ScreenState();
}

class _V4l2ScreenState extends AppModuleState<V4l2Screen> {
  @override
  String get module => 'config.v4l2';

  final _sink = V4l2Sink();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: BlocBuilder<ProfilesBloc, ProfilesState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: .stretch,
              children: [
                InfoBar(
                  isLong: true,
                  title: Text(translatedText(key: 'infoBar.title')),
                  content: SelectableText.rich(
                    TextSpan(
                      style: typography.body,
                      children: [
                        TextSpan(text: translatedText(key: 'infoBar.description')),
                        TextSpan(text: translatedText(key: 'infoBar.create')),
                        TextSpan(
                          text: 'sudo modprobe v4l2loopback\n\n',
                          style: TextStyle(fontFamily: 'monospace'),
                        ),
                        TextSpan(text: translatedText(key: 'infoBar.stream')),
                        TextSpan(
                          text: 'ffplay -i /dev/videoN\nvlc v4l2:///dev/videoN\n\n',
                          style: TextStyle(fontFamily: 'monospace'),
                        ),
                        LinkSpan(
                          text: translatedText(key: 'infoBar.moreInfo'),
                          onTap: () => launchUrlString(
                            "https://github.com/Genymobile/scrcpy/blob/v$supportedScrcpyVersion/doc/v4l2.md",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  padding: EdgeInsets.zero,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ConfigItem(
                        icon: FluentIcons.funnel_chart,
                        hasDefault: true,
                        cliArgument: _sink,
                        child: ConfigTextBox(
                          value: state.getFor(_sink),
                          onChanged: (newValue) =>
                              context.read<ProfilesBloc>().add(UpdateProfileArgEvent(_sink, newValue)),
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
