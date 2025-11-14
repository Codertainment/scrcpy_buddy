import 'package:fluent_ui/fluent_ui.dart';
import 'package:scrcpy_buddy/presentation/widgets/app_widgets.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class ThemeBrightnessSetting extends AppStatelessWidget {
  final Preference<Brightness?> brightnessPreference;

  const ThemeBrightnessSetting({super.key, required this.brightnessPreference});

  @override
  String get module => 'settings.themeBrightness';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...Brightness.values.map(
          (brightness) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: RadioButton(
              checked: brightnessPreference.getValue() == brightness,
              onChanged: (checked) {
                if (checked) {
                  brightnessPreference.setValue(brightness);
                }
              },
              content: Text(translatedText(context, key: brightness.name)),
            ),
          ),
        ),
        RadioButton(
          checked: brightnessPreference.getValue() == null,
          onChanged: (checked) {
            if (checked) {
              brightnessPreference.setValue(null);
            }
          },
          content: Text(translatedText(context, key: 'system')),
        ),
      ],
    );
  }
}
