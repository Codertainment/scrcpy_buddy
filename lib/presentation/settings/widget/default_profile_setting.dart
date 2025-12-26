import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrcpy_buddy/application/app_settings.dart';
import 'package:scrcpy_buddy/application/profiles_bloc/profiles_bloc.dart';
import 'package:scrcpy_buddy/presentation/widgets/app_widgets.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class DefaultProfileSetting extends StatefulWidget {
  const DefaultProfileSetting({super.key});

  @override
  State<DefaultProfileSetting> createState() => _DefaultProfileSettingState();
}

class _DefaultProfileSettingState extends AppModuleState<DefaultProfileSetting> {
  late final _settings = context.read<AppSettings>();

  @override
  String get module => 'settings.defaultProfile';

  @override
  Widget build(BuildContext context) {
    return PreferenceBuilder<bool>(
      preference: _settings.isLastUsedProfileDefault,
      builder: (context, isLastUsedProfileDefault) {
        return PreferenceBuilder<int>(
          preference: _settings.defaultProfileId,
          builder: (context, profileId) => BlocBuilder<ProfilesBloc, ProfilesState>(
            builder: (context, state) {
              return ComboBox(
                value: isLastUsedProfileDefault ? -1 : profileId,
                onChanged: (newProfileId) {
                  if (newProfileId == -1) {
                    _settings.isLastUsedProfileDefault.setValue(true);
                  } else {
                    _settings.isLastUsedProfileDefault.setValue(false);
                    _settings.defaultProfileId.setValue(newProfileId ?? -1);
                  }
                },
                items: [
                  ComboBoxItem(value: -1, child: Text(translatedText(key: 'lastUsed'))),
                  ...state.allProfiles.map(
                    (profile) => ComboBoxItem(value: profile.id, child: Text(profile.name ?? 'Default')),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
