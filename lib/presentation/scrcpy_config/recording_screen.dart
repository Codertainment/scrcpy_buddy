import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrcpy_buddy/application/model/scrcpy/arguments/recording/record.dart';
import 'package:scrcpy_buddy/application/profiles_bloc/profiles_bloc.dart';
import 'package:scrcpy_buddy/presentation/extension/context_extension.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/widgets/config_item.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/widgets/config_text_box.dart';
import 'package:scrcpy_buddy/presentation/widgets/app_widgets.dart';

class RecordingScreen extends StatefulWidget {
  const RecordingScreen({super.key});

  @override
  State<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends AppModuleState<RecordingScreen> {
  late final _profilesBloc = context.read<ProfilesBloc>();

  @override
  String get module => 'config.recording';

  final _record = Record();

  final _xTypeGroups = [
    XTypeGroup(label: 'MP4', extensions: ['mp4', 'm4a', 'aac']),
    XTypeGroup(label: 'Matroska', extensions: ['mkv', 'mka']),
    XTypeGroup(label: 'OPUS', extensions: ['opus']),
    XTypeGroup(label: 'FLAC', extensions: ['flac']),
    XTypeGroup(label: 'WAV', extensions: ['wav']),
  ];

  Future<void> _openSaveToSelector(String? currentValue) async {
    final parts = currentValue?.split(Platform.pathSeparator);
    final path = parts?.sublist(0, parts.length - 1).join(Platform.pathSeparator);
    final file = parts?.lastOrNull;
    final result = await getSaveLocation(
      acceptedTypeGroups: _xTypeGroups,
      initialDirectory: path,
      suggestedName: file,
      canCreateDirectories: true,
    );
    if (result != null) {
      _profilesBloc.add(UpdateProfileArgEvent(_record, result.path));
    }
  }

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
                Card(
                  padding: EdgeInsets.zero,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ConfigItem(
                        icon: FluentIcons.save,
                        cliArgument: _record,
                        child: Row(
                          children: [
                            ConfigTextBox(
                              maxWidth: context.windowSize.width * 0.4,
                              value: state.getFor(_record),
                              onChanged: (newValue) => _profilesBloc.add(UpdateProfileArgEvent(_record, newValue)),
                            ),
                            const SizedBox(width: 4),
                            IconButton(
                              icon: WindowsIcon(WindowsIcons.file_explorer),
                              onPressed: () => _openSaveToSelector(state.getFor(_record)),
                            ),
                          ],
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
