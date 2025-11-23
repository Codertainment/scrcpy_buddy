import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrcpy_buddy/application/args_bloc/args_bloc.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/widgets/config_item.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/widgets/config_text_box.dart';
import 'package:scrcpy_buddy/presentation/widgets/app_widgets.dart';

import 'package:scrcpy_buddy/application/model/scrcpy/scrcpy_arg.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends AppModuleState<VideoScreen> {
  late final _argsBloc = context.read<ArgsBloc>();

  @override
  String get module => 'config.video';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: BlocBuilder<ArgsBloc, ArgsState>(
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
                      checked: state.args[NoVideo()] ?? false,
                      onChanged: (checked) => _argsBloc.add(UpdateArgsEvent(NoVideo(), checked)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),
                  ConfigItem(
                    label: 'video.size',
                    child: ConfigTextBox(
                      value: state.args[VideoSize()],
                      isNumberOnly: true,
                      onChanged: (newValue) =>
                          _argsBloc.add(UpdateArgsEvent(VideoSize(), newValue)),
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
