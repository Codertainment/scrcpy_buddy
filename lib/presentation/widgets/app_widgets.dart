import 'package:fluent_ui/fluent_ui.dart';
import 'package:scrcpy_buddy/presentation/extension/context_extension.dart';
import 'package:scrcpy_buddy/presentation/extension/translation_extension.dart';

abstract class AppModuleState<T extends StatefulWidget> extends State<T> {
  String get module;

  String translatedText({required String key, Map<String, String>? translationParams}) {
    return context.translatedText(module: module, key: key, translationParams: translationParams);
  }

  Typography get typography => context.typography;

  Future<void> showInfoBar({required String title, InfoBarSeverity severity = InfoBarSeverity.info, String? content}) =>
      context.showInfoBar(title: title, severity: severity, content: content);
}

abstract class AppStatelessWidget extends StatelessWidget {
  const AppStatelessWidget({super.key});

  String get module;

  String translatedText(BuildContext context, {required String key, Map<String, String>? translationParams}) {
    return context.translatedText(module: module, key: key, translationParams: translationParams);
  }

  Future<void> showInfoBar({
    required BuildContext context,
    required String title,
    InfoBarSeverity severity = InfoBarSeverity.info,
    String? content,
  }) => context.showInfoBar(title: title, severity: severity, content: content);
}
