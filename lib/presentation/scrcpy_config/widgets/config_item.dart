import 'package:fluent_ui/fluent_ui.dart';
import 'package:scrcpy_buddy/presentation/extension/context_extension.dart';
import 'package:scrcpy_buddy/presentation/extension/translation_extension.dart';
import 'package:scrcpy_buddy/presentation/widgets/app_widgets.dart';

class ConfigItem extends AppStatelessWidget {
  final IconData? icon;
  final bool hasDefault;
  final String label;
  final Widget child;

  const ConfigItem({super.key, this.icon, this.hasDefault = false, required this.label, required this.child});

  @override
  String get module => 'config.$label';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        children: [
          if (icon != null) ...[Icon(icon, size: 24), const SizedBox(width: 12)],
          Expanded(
            child: Column(
              mainAxisSize: .min,
              crossAxisAlignment: .stretch,
              children: [
                Row(
                  children: [
                    Text(translatedText(context, key: 'title'), style: context.typography.bodyStrong),
                    const SizedBox(width: 8),
                    Tooltip(
                      richMessage: TextSpan(
                        children: [
                          TextSpan(
                            text: translatedText(context, key: 'arg'),
                            style: TextStyle(fontFamily: 'monospace'),
                          ),
                          if (hasDefault)
                            TextSpan(
                              text:
                                  '\n${context.translatedText(
                                    key: 'config.defaultValue',
                                    translationParams: {'value': translatedText(context, key: 'default')},
                                  )}',
                            ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: context.theme.resources.subtleFillColorSecondary,
                        child: WindowsIcon(WindowsIcons.help, size: 8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(translatedText(context, key: 'description'), style: context.typography.body),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Align(alignment: Alignment.centerRight, child: child),
        ],
      ),
    );
  }
}
