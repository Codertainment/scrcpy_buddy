import 'package:fluent_ui/fluent_ui.dart';

class IconTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Icon icon;
  final String text;

  const IconTextButton({super.key, required this.icon, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Button(
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [icon, const SizedBox(width: 4), Text(text)],
      ),
    );
  }
}
