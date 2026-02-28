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
    return StreamBuilder<Brightness?>(
      stream: brightnessPreference,
      builder: (context, brightness) => RadioGroup<AppThemeBrightness>(
        groupValue: AppThemeBrightness.fromBrightness(brightness.data),
        onChanged: (newValue) => brightnessPreference.setValue(newValue?.toBrightness()),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: AppThemeBrightness.values
              .map(
                (brightness) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: RadioButton(
                    value: brightness,
                    content: Text(translatedText(context, key: brightness.name)),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

enum AppThemeBrightness {
  light,
  dark,
  system;

  Brightness? toBrightness() => switch (this) {
    dark => Brightness.dark,
    system => null,
    light => Brightness.light,
  };

  static AppThemeBrightness fromBrightness(Brightness? brightness) => switch (brightness) {
    Brightness.dark => dark,
    null => system,
    Brightness.light => light,
  };
}
