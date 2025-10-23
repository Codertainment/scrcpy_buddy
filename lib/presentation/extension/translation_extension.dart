import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:scrcpy_buddy/presentation/extension/context_extension.dart';

extension TranslationExtension on BuildContext {
  String translatedText({String? module, required String key, Map<String, String>? translationParams}) {
    return FlutterI18n.translate(this, '${module != null ? '$module.' : ''}$key', translationParams: translationParams);
  }

  bool get isEnglish => Localizations.localeOf(this).languageCode == 'en';
}

abstract class AppModuleState<T extends StatefulWidget> extends State<T> {
  String get module;

  String translatedText({required String key, Map<String, String>? translationParams}) {
    return context.translatedText(module: module, key: key, translationParams: translationParams);
  }

  Typography get typography => context.typography;
}

abstract class AppStatelessWidget extends StatelessWidget {
  const AppStatelessWidget({super.key});

  String get module;

  String translatedText(BuildContext context, {required String key, Map<String, String>? translationParams}) {
    return context.translatedText(module: module, key: key, translationParams: translationParams);
  }
}
