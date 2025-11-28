import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:scrcpy_buddy/main.dart';
import 'package:scrcpy_buddy/presentation/widgets/app_widgets.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ModesInfoBar extends AppStatelessWidget {
  const ModesInfoBar({super.key});

  @override
  String get module => 'config.control.modesInfoBar';

  @override
  Widget build(BuildContext context) {
    final link = TextStyle(decoration: TextDecoration.underline, color: Colors.blue);
    return InfoBar(
      isLong: true,
      title: Text(translatedText(context, key: 'title')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(translatedText(context, key: 'description')),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: translatedText(context, key: 'keyboard'),
                  style: link,
                  recognizer: TapGestureRecognizer()..onTap = _openKeyboardDocs,
                ),
                TextSpan(
                  text: translatedText(context, key: 'mouse'),
                  style: link,
                  recognizer: TapGestureRecognizer()..onTap = _openMouseDocs,
                ),
                TextSpan(
                  text: translatedText(context, key: 'gamepad'),
                  style: link,
                  recognizer: TapGestureRecognizer()..onTap = _openGamepadDocs,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openKeyboardDocs() =>
      _launchUrlString("https://github.com/Genymobile/scrcpy/blob/v$supportedScrcpyVersion/doc/keyboard.md");

  void _openMouseDocs() =>
      _launchUrlString("https://github.com/Genymobile/scrcpy/blob/v$supportedScrcpyVersion/doc/mouse.md");

  void _openGamepadDocs() =>
      _launchUrlString("https://github.com/Genymobile/scrcpy/blob/v$supportedScrcpyVersion/doc/gamepad.md");

  void _launchUrlString(String url) async {
    if (await canLaunchUrlString(url)) {
      launchUrlString(url);
    }
  }
}
