import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/gestures.dart';

class LinkSpan extends TextSpan {
  final VoidCallback onTap;

  LinkSpan({required super.text, required this.onTap})
    : super(
        mouseCursor: SystemMouseCursors.click,
        style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue),
      );

  @override
  GestureRecognizer? get recognizer => TapGestureRecognizer()..onTap = onTap;
}
