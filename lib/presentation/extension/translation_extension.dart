import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:scrcpy_buddy/presentation/extension/context_extension.dart';

extension TranslationExtension on BuildContext {
  String translatedText({String? module, required String key, Map<String, String>? translationParams}) {
    return FlutterI18n.translate(this, '${module != null ? '$module.' : ''}$key', translationParams: translationParams);
  }

  bool get isEnglish => Localizations.localeOf(this).languageCode == 'en';
}
