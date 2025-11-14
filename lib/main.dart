import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart' as flutter_acrylic;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:scrcpy_buddy/application/app_settings.dart';
import 'package:scrcpy_buddy/application/args_bloc/args_bloc.dart';
import 'package:scrcpy_buddy/application/model/scrcpy/scrcpy_arg.dart';
import 'package:scrcpy_buddy/application/scrcpy_bloc/scrcpy_bloc.dart';
import 'package:scrcpy_buddy/application/shared_prefs.dart';
import 'package:scrcpy_buddy/main.reflectable.dart';
import 'package:scrcpy_buddy/presentation/devices/bloc/devices_bloc.dart';
import 'package:scrcpy_buddy/routes.dart';
import 'package:system_theme/system_theme.dart';
import 'package:window_manager/window_manager.dart';

import 'injector.dart';

const scrcpyArg = ScrcpyArg();

final _prefs = SharedPrefs();

void main() async {
  await _prefs.initialize();
  initializeReflectable();
  WidgetsFlutterBinding.ensureInitialized();
  await flutter_acrylic.Window.initialize();
  if (defaultTargetPlatform == TargetPlatform.windows) {
    await flutter_acrylic.Window.setEffect(effect: flutter_acrylic.WindowEffect.acrylic);
  }
  await WindowManager.instance.ensureInitialized();
  windowManager.waitUntilReadyToShow().then((_) async {
    await windowManager.setMinimumSize(const Size(500, 600));
    await windowManager.show();
  });
  await SystemTheme.accentColor.load();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final _settings = AppSettings(_prefs);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ...providers,
        Provider(create: (_) => _prefs),
        Provider<AppSettings>(create: (context) => _settings),
      ],
      child: StreamBuilder<Brightness?>(
        stream: _settings.themeBrightness,
        builder: (context, brightness) => FluentApp.router(
          debugShowCheckedModeBanner: false,
          title: 'scrcpy Buddy',
          themeMode: brightness.data == null
              ? ThemeMode.system
              : (brightness.data!.isDark ? ThemeMode.dark : ThemeMode.light),
          theme: FluentThemeData(accentColor: SystemTheme.accentColor.accent.toAccentColor()),
          darkTheme: FluentThemeData(
            brightness: Brightness.dark,
            accentColor: SystemTheme.accentColor.accent.toAccentColor(),
          ),
          builder: (context, child) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => ArgsBloc()),
                BlocProvider(create: (context) => ScrcpyBloc(context.read(), context.read(), context.read())),
                BlocProvider(create: (context) => DevicesBloc(context.read())),
              ],
              child: child!,
            );
          },
          routeInformationParser: router.routeInformationParser,
          routerDelegate: router.routerDelegate,
          routeInformationProvider: router.routeInformationProvider,
          localizationsDelegates: [
            FlutterI18nDelegate(
              translationLoader: FileTranslationLoader(basePath: 'assets/i18n'),
              missingTranslationHandler: (key, locale) {
                print("--- Missing Key: $key, languageCode: ${locale?.languageCode ?? 'null'}");
              },
            ),
            GlobalWidgetsLocalizations.delegate,
          ],
          // builder: FlutterI18n.rootAppBuilder(),
        ),
      ),
    );
  }
}
