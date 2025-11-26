import 'package:fluent_ui/fluent_ui.dart';
import 'package:scrcpy_buddy/presentation/extension/translation_extension.dart';

class DropdownPlaceholder extends StatelessWidget {
  const DropdownPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(context.translatedText(key: 'config.dropdownPlaceholder'));
  }
}
