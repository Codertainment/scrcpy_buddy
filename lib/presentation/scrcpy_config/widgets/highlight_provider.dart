import 'package:fluent_ui/fluent_ui.dart';

/// An [InheritedWidget] that provides a highlight label down the widget tree.
///
/// Used by [ConfigItem] to determine if it should be highlighted after
/// a search result navigation.
class HighlightProvider extends InheritedWidget {
  final String? highlightLabel;

  const HighlightProvider({super.key, required this.highlightLabel, required super.child});

  static String? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<HighlightProvider>()?.highlightLabel;
  }

  @override
  bool updateShouldNotify(HighlightProvider oldWidget) {
    return highlightLabel != oldWidget.highlightLabel;
  }
}
