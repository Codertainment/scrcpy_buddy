import 'package:fluent_ui/fluent_ui.dart';
import 'package:scrcpy_buddy/presentation/extension/translation_extension.dart';
import 'package:scrcpy_buddy/presentation/widgets/app_widgets.dart';

enum ProfileNameDialogMode {
  create(titleKey: 'createTitle', descriptionKey: 'createDescription'),
  edit(titleKey: 'editTitle', descriptionKey: 'editDescription');

  const ProfileNameDialogMode({required this.titleKey, required this.descriptionKey});

  final String titleKey;
  final String descriptionKey;
}

Future<String?> showProfileNameDialog({
  required BuildContext context,
  String? name,
  ProfileNameDialogMode mode = .create,
}) => showDialog(
  context: context,
  builder: (context) => _ProfileNameDialog(name: name, mode: mode),
);

class _ProfileNameDialog extends StatefulWidget {
  final String? name;
  final ProfileNameDialogMode mode;

  const _ProfileNameDialog({this.name, required this.mode});

  @override
  State<_ProfileNameDialog> createState() => _ProfileNameDialogState();
}

class _ProfileNameDialogState extends AppModuleState<_ProfileNameDialog> {
  late final _textController = TextEditingController(text: widget.name);
  late bool _saveButtonEnabled = _textController.text.isNotEmpty;

  final int _maxLength = 30;

  @override
  String get module => 'profile.nameDialog';

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: Text(translatedText(key: widget.mode.titleKey)),
      content: InfoLabel(
        label: translatedText(key: widget.mode.descriptionKey),
        child: SizedBox(
          height: 50,
          child: TextBox(
            controller: _textController,
            maxLength: _maxLength,
            autofocus: true,
            maxLines: 1,
            suffix: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text("${_textController.text.length}/$_maxLength", style: typography.caption),
            ),
            suffixMode: .editing,
            placeholder: translatedText(key: 'placeholder'),
            onChanged: (newName) => setState(() => _saveButtonEnabled = newName.isNotEmpty),
          ),
        ),
      ),
      actions: [
        Button(
          child: Text(context.translatedText(key: 'common.cancel')),
          onPressed: () => Navigator.pop(context),
        ),
        FilledButton(
          onPressed: _saveButtonEnabled ? () => Navigator.pop(context, _textController.text) : null,
          child: Text(context.translatedText(key: 'common.save')),
        ),
      ],
    );
  }
}
