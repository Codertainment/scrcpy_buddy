import 'package:fluent_ui/fluent_ui.dart';

extension ContextExtension on BuildContext {
  Typography get typography => FluentTheme.of(this).typography;

  NavigatorState get navigator => Navigator.of(this);

  Future<T?> openDialog<T>(Widget child) =>
      showDialog<T>(context: this, barrierDismissible: true, builder: (_) => child);

  Future<void> showInfoBar({
    required String title,
    InfoBarSeverity severity = InfoBarSeverity.info,
    Widget? action,
    String? content,
  }) => displayInfoBar(
    this,
    builder: (context, close) {
      return InfoBar(
        title: Text(title),
        content: content != null ? Text(content) : null,
        action: action ?? IconButton(icon: const WindowsIcon(WindowsIcons.clear), onPressed: close),
        severity: severity,
      );
    },
  );
}
