import 'package:fluent_ui/fluent_ui.dart';
import 'package:scrcpy_buddy/presentation/extension/context_extension.dart';
import 'package:scrcpy_buddy/presentation/widgets/app_widgets.dart';

class SettingsItem extends AppStatelessWidget {
  final String groupKey;
  final String titleKey;
  final bool shouldShowDescription;
  final String descriptionKey;
  final BoxConstraints? childConstraints;
  final Widget child;

  const SettingsItem({
    super.key,
    required this.groupKey,
    this.titleKey = 'title',
    this.shouldShowDescription = false,
    this.descriptionKey = 'description',
    this.childConstraints,
    required this.child,
  });

  @override
  String get module => 'settings.$groupKey';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(translatedText(context, key: titleKey), style: context.typography.bodyStrong),
        const SizedBox(height: 8),
        if (childConstraints != null) ...[ConstrainedBox(constraints: childConstraints!, child: child)] else ...[child],
        if (shouldShowDescription) ...[
          const SizedBox(height: 4),
          Text(translatedText(context, key: descriptionKey), style: context.typography.caption),
        ],
        const SizedBox(height: 24),
      ],
    );
  }
}
