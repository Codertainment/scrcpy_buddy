import 'package:fluent_ui/fluent_ui.dart';
import 'package:scrcpy_buddy/presentation/extension/context_extension.dart';
import 'package:scrcpy_buddy/presentation/extension/translation_extension.dart';
import 'package:scrcpy_buddy/presentation/widgets/app_widgets.dart';

class ConfigItemBase extends StatefulWidget {
  final IconData? icon;
  final String titleKey;
  final String descriptionKey;
  final String? defaultValueKey;
  final String arg;
  final Widget child;
  final bool isHighlighted;

  const ConfigItemBase({
    super.key,
    this.icon,
    this.defaultValueKey,
    this.isHighlighted = false,
    required this.titleKey,
    required this.descriptionKey,
    required this.arg,
    required this.child,
  });

  @override
  State<ConfigItemBase> createState() => _ConfigItemBaseState();
}

class _ConfigItemBaseState extends AppModuleState<ConfigItemBase> with SingleTickerProviderStateMixin {
  late final AnimationController _highlightController;
  late final Animation<double> _highlightAnimation;
  final _itemKey = GlobalKey();

  @override
  String get module => 'config';

  @override
  void initState() {
    super.initState();
    _highlightController = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000));
    _highlightAnimation = CurvedAnimation(parent: _highlightController, curve: Curves.easeOut);

    if (widget.isHighlighted) {
      _highlightController.value = 1.0;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToItem();
        // Start fading out after a short delay
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) _highlightController.reverse();
        });
      });
    }
  }

  void _scrollToItem() {
    final itemContext = _itemKey.currentContext;
    if (itemContext != null) {
      Scrollable.ensureVisible(
        itemContext,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        alignment: 0.3,
      );
    }
  }

  @override
  void didUpdateWidget(ConfigItemBase oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isHighlighted && !oldWidget.isHighlighted) {
      _highlightController.value = 1.0;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToItem();
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) _highlightController.reverse();
        });
      });
    }
  }

  @override
  void dispose() {
    _highlightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _highlightAnimation,
      builder: (context, child) {
        final highlightAlpha = _highlightAnimation.value * 0.12 * 255;
        return Container(
          key: _itemKey,
          decoration: BoxDecoration(
            color: highlightAlpha > 0 ? context.theme.accentColor.withAlpha(highlightAlpha.toInt()) : null,
            borderRadius: BorderRadius.circular(4),
          ),
          child: child,
        );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Row(
          children: [
            if (widget.icon != null) ...[Icon(widget.icon, size: 24), const SizedBox(width: 12)],
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Text(translatedText(key: widget.titleKey), style: context.typography.bodyStrong),
                      const SizedBox(width: 8),
                      Tooltip(
                        richMessage: TextSpan(
                          children: [
                            TextSpan(
                              text: widget.arg,
                              style: TextStyle(fontFamily: 'monospace'),
                            ),
                            if (widget.defaultValueKey != null)
                              TextSpan(
                                text:
                                    '\n${context.translatedText(key: 'config.defaultValue', translationParams: {'value': translatedText(key: widget.defaultValueKey!)})}',
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
                  Text(translatedText(key:widget.descriptionKey), style: context.typography.body),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Align(alignment: Alignment.centerRight, child: widget.child),
          ],
        ),
      ),
    );
  }
}
