import 'package:fluent_ui/fluent_ui.dart';
import 'package:scrcpy_buddy/application/model/scrcpy/scrcpy_cli_argument.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/widgets/config_item_base.dart';
import 'package:scrcpy_buddy/presentation/widgets/app_widgets.dart';

class ConfigItem extends AppStatelessWidget {
  final IconData? icon;
  final bool hasDefault;
  final ScrcpyCliArgument cliArgument;
  final Widget child;

  const ConfigItem({super.key, this.icon, this.hasDefault = false, required this.cliArgument, required this.child});

  @override
  String get module => 'config.${cliArgument.label}';

  @override
  Widget build(BuildContext context) {
    return ConfigItemBase(
      icon: icon,
      defaultValueKey: hasDefault ? '${cliArgument.label}.default' : null,
      titleKey: '${cliArgument.label}.title',
      descriptionKey: '${cliArgument.label}.description',
      arg: cliArgument.argument,
      child: child,
    );
  }
}
