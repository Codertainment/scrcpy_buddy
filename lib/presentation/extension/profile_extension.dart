import 'package:flutter/widgets.dart';
import 'package:scrcpy_buddy/application/model/profile.dart';
import 'package:scrcpy_buddy/presentation/extension/translation_extension.dart';

extension ProfileExtension on Profile {
  String getName(BuildContext context) {
    return name ?? context.translatedText(key: 'profiles.default');
  }
}
