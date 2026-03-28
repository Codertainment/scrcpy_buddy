import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

extension ContextExtension on BuildContext {
  FluentThemeData get theme => FluentTheme.of(this);

  Typography get typography => theme.typography;

  NavigatorState get navigator => Navigator.of(this);

  Size get windowSize => read<Size>();

  Color get errorColor => theme.brightness == Brightness.dark ? Colors.red.lighter : Colors.errorPrimaryColor;

  Future<T?> openDialog<T>(Widget child) =>
      showDialog<T>(context: this, barrierDismissible: true, builder: (_) => child);

  Future<void> showInfoBar({
    required String title,
    InfoBarSeverity severity = InfoBarSeverity.info,
    Widget? action,
    String? content,
    bool? isLong,
    Duration? duration,
  }) => displayInfoBar(
    this,
    duration: duration ?? Duration(seconds: 5),
    builder: (context, close) {
      return InfoBar(
        title: Text(title),
        isLong: isLong ?? false,
        content: content != null ? Text(content) : null,
        action: action,
        onClose: close,
        severity: severity,
      );
    },
  );
}
