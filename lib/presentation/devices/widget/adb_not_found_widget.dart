import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:scrcpy_buddy/presentation/extension/context_extension.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/widgets/link_span.dart';
import 'package:scrcpy_buddy/presentation/widgets/app_widgets.dart';
import 'package:scrcpy_buddy/routes.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AdbNotFoundWidget extends AppStatelessWidget {
  const AdbNotFoundWidget({super.key});

  @override
  String get module => 'devices.adbNotFound';

  void _openAdbDocs() => _launchUrlString("https://developer.android.com/tools/adb");

  void _launchUrlString(String url) async {
    if (await canLaunchUrlString(url)) {
      launchUrlString(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: .center,
          children: [
            WindowsIcon(WindowsIcons.warning),
            const SizedBox(width: 4),
            Text(translatedText(context, key: 'title'), style: context.typography.title),
          ],
        ),
        const SizedBox(height: 8),
        RichText(
          textAlign: .center,
          text: TextSpan(
            style: context.typography.body,
            children: [
              TextSpan(text: translatedText(context, key: 'description')),
              LinkSpan(
                text: translatedText(context, key: 'settings'),
                onTap: () => context.go(AppRoute.settings),
              ),
              TextSpan(text: '\n'),
              LinkSpan(
                text: translatedText(context, key: 'hint'),
                onTap: _openAdbDocs,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
