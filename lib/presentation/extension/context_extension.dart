import 'package:fluent_ui/fluent_ui.dart';

extension ContextExtension on BuildContext {
  Typography get typography => FluentTheme.of(this).typography;

  NavigatorState get navigator => Navigator.of(this);

  Future<T?> openDialog<T>(Widget child) =>
      showDialog<T>(context: this, barrierDismissible: true, builder: (_) => child);
}
