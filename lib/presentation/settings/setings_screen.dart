import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:scrcpy_buddy/application/app_settings.dart';
import 'package:scrcpy_buddy/presentation/settings/widget/scrcpy_executable_setting.dart';
import 'package:scrcpy_buddy/presentation/settings/widget/settings_item.dart';
import 'package:scrcpy_buddy/presentation/settings/widget/theme_brightness_setting.dart';
import 'package:scrcpy_buddy/presentation/widgets/app_widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends AppModuleState<SettingsScreen> {
  late final _settings = context.read<AppSettings>();
  final _defaultConstraints = BoxConstraints(maxWidth: 600);

  @override
  String get module => 'settings';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SettingsItem(
            groupKey: 'scrcpyExecutable',
            shouldShowDescription: true,
            childConstraints: _defaultConstraints,
            child: ScrcpyExecutableSetting(),
          ),
          SettingsItem(
            groupKey: 'themeBrightness',
            childConstraints: _defaultConstraints,
            child: ThemeBrightnessSetting(brightnessPreference: _settings.themeBrightness),
          ),
        ],
      ),
    );
  }
}
