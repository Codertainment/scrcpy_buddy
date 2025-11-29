import 'package:fluent_ui/fluent_ui.dart';
import 'package:scrcpy_buddy/presentation/extension/context_extension.dart';
import 'package:scrcpy_buddy/presentation/extension/translation_extension.dart';
import 'package:scrcpy_buddy/presentation/widgets/app_widgets.dart';

class ConfigItemBase extends AppStatelessWidget {
  final IconData? icon;
  final String titleKey;
  final String descriptionKey;
  final String? defaultValueKey;
  final String arg;
  final Widget child;

  const ConfigItemBase({
    super.key,
    this.icon,
    this.defaultValueKey,
    required this.titleKey,
    required this.descriptionKey,
    required this.arg,
    required this.child,
  });

  @override
  String get module => 'config';

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
                    Text(translatedText(context, key: titleKey), style: context.typography.bodyStrong),
                    const SizedBox(width: 8),
                    Tooltip(
                      richMessage: TextSpan(
                        children: [
                          TextSpan(
                            text: arg,
                            style: TextStyle(fontFamily: 'monospace'),
                          ),
                          if (defaultValueKey != null)
                            TextSpan(
                              text:
                                  '\n${context.translatedText(
                                    key: 'config.defaultValue',
                                    translationParams: {'value': translatedText(context, key: defaultValueKey!)},
                                  )}',
                            ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: context.theme.resources.cardStrokeColorDefault,
                        foregroundColor: context.theme.resources.textFillColorPrimary,
                        child: WindowsIcon(WindowsIcons.help, size: 8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(translatedText(context, key: descriptionKey), style: context.typography.body),
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
