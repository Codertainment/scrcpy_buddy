import 'package:fluent_ui/fluent_ui.dart';
import 'package:scrcpy_buddy/presentation/extension/translation_extension.dart';

Future<bool?> showDangerActionConfirmationDialog(
  BuildContext context, {
  required String titleKey,
  String? messageKey,
  String? message,
  required String actionKey,
}) async {
  assert(messageKey != null || message != null);
  return await showDialog<bool>(
    context: context,
    builder: (context) => ContentDialog(
      title: Text(context.translatedText(key: titleKey)),
      content: Text(message ?? context.translatedText(key: messageKey!)),
      actions: [
        Button(
          child: Text(context.translatedText(key: actionKey)),
          onPressed: () => Navigator.pop(context, true),
        ),
        FilledButton(
          child: Text(context.translatedText(key: 'common.cancel')),
          onPressed: () => Navigator.pop(context, false),
        ),
      ],
    ),
  );
}
