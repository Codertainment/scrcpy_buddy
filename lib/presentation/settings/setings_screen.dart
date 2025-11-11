import 'package:fluent_ui/fluent_ui.dart';
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
    return const Placeholder();
  }
}
