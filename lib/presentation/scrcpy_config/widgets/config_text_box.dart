import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:scrcpy_buddy/presentation/extension/context_extension.dart';
import 'package:scrcpy_buddy/presentation/extension/translation_extension.dart';

class ConfigTextBox extends StatefulWidget {
  final String? value;
  final bool isNumberOnly;
  final double? maxWidth;
  final String? defaultValue;
  final void Function(String? newValue) onChanged;

  const ConfigTextBox({
    super.key,
    required this.value,
    this.isNumberOnly = false,
    required this.onChanged,
    this.maxWidth,
    this.defaultValue,
  });

  @override
  State<ConfigTextBox> createState() => _ConfigTextBoxState();
}

class _ConfigTextBoxState extends State<ConfigTextBox> {
  late final _controller = TextEditingController(text: widget.value);

  @override
  void didUpdateWidget(covariant ConfigTextBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value == null) {
      _controller.clear();
    } else if (widget.value != oldWidget.value && widget.value != _controller.text) {
      _controller.text = widget.value!.toString();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: widget.maxWidth != null ? widget.maxWidth! : context.windowSize.width * 0.15,
      ),
      child: TextBox(
        controller: _controller,
        placeholder: widget.defaultValue != null
            ? context.translatedText(key: 'config.defaultValue', translationParams: {'value': widget.defaultValue!})
            : null,
        inputFormatters: widget.isNumberOnly ? [FilteringTextInputFormatter.digitsOnly] : null,
        suffix: _controller.text.isNotEmpty
            ? IconButton(icon: WindowsIcon(WindowsIcons.clear), onPressed: () => widget.onChanged(null))
            : null,
        onChanged: (newValue) {
          if (newValue.isEmpty) {
            widget.onChanged(null);
          } else {
            widget.onChanged(newValue);
          }
        },
      ),
    );
  }
}
