import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:scrcpy_buddy/presentation/home/home_screen.dart';
import 'package:system_theme/system_theme.dart';

import 'injector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemTheme.accentColor.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: FluentApp(
        title: 'scrcpy Buddy',
        themeMode: ThemeMode.system,
        theme: FluentThemeData(accentColor: SystemTheme.accentColor.accent.toAccentColor()),
        darkTheme: FluentThemeData(
          brightness: Brightness.dark,
          accentColor: SystemTheme.accentColor.accent.toAccentColor(),
        ),
        home: HomeScreen(),
        localizationsDelegates: [
          FlutterI18nDelegate(
            translationLoader: FileTranslationLoader(basePath: 'assets/i18n'),
            missingTranslationHandler: (key, locale) {
              print("--- Missing Key: $key, languageCode: ${locale?.languageCode ?? 'null'}");
            },
          ),
          GlobalWidgetsLocalizations.delegate,
        ],
        builder: FlutterI18n.rootAppBuilder(),
      ),
    );
  }
}
