import 'package:fluent_ui/fluent_ui.dart';
import 'package:scrcpy_buddy/presentation/extension/context_extension.dart';
import 'package:scrcpy_buddy/presentation/widgets/app_widgets.dart';

class ConfigItem extends AppStatelessWidget {
  final String label;
  final Widget child;

  const ConfigItem({super.key, required this.label, required this.child});

  @override
  String get module => 'config.$label';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          Expanded(
            flex: 5,
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
                        text: translatedText(context, key: 'arg'),
                        style: TextStyle(fontFamily: 'monospace'),
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
          Flexible(
            child: Align(alignment: Alignment.centerRight, child: child),
          ),
        ],
      ),
    );
  }
}
