import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';

class ConfigTextBox extends StatefulWidget {
  final String? value;
  final bool isNumberOnly;
  final void Function(String? newValue) onChanged;

  const ConfigTextBox({super.key, required this.value, required this.isNumberOnly, required this.onChanged});

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
    return TextBox(
      controller: _controller,
      inputFormatters: widget.isNumberOnly ? [FilteringTextInputFormatter.digitsOnly] : null,
      suffix: _controller.text.isNotEmpty ? IconButton(icon: WindowsIcon(WindowsIcons.clear), onPressed: () => widget.onChanged(null)) : null,
      onChanged: (newValue) {
        if (newValue.isEmpty) {
          widget.onChanged(null);
        } else {
          widget.onChanged(newValue);
        }
      },
    );
  }
}
