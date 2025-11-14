import 'package:fluent_ui/fluent_ui.dart';
import 'package:scrcpy_buddy/presentation/settings/widget/scrcpy_executable_setting.dart';
import 'package:scrcpy_buddy/presentation/settings/widget/settings_item.dart';
import 'package:scrcpy_buddy/presentation/widgets/app_widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends AppModuleState<SettingsScreen> {
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
            childConstraints: BoxConstraints(maxWidth: 600),
            child: ScrcpyExecutableSetting(),
          ),
        ],
      ),
    );
  }
}
