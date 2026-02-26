import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:scrcpy_buddy/application/app_settings.dart';
import 'package:scrcpy_buddy/application/model/scrcpy/scrcpy_arg.dart';
import 'package:scrcpy_buddy/application/model/scrcpy/scrcpy_cli_argument.dart';
import 'package:scrcpy_buddy/application/objectbox.dart';
import 'package:scrcpy_buddy/application/profiles_bloc/profiles_bloc.dart';
import 'package:scrcpy_buddy/application/scrcpy_bloc/scrcpy_bloc.dart';
import 'package:scrcpy_buddy/application/shared_prefs.dart';
import 'package:scrcpy_buddy/init.dart';
import 'package:scrcpy_buddy/presentation/devices/bloc/devices_bloc.dart';
import 'package:scrcpy_buddy/presentation/search/bloc/search_bloc.dart';
import 'package:scrcpy_buddy/routes.dart';
import 'package:system_theme/system_theme.dart';
import 'package:window_manager/window_manager.dart';

import 'injector.dart';

const supportedScrcpyVersion = "3.3.4";

const scrcpyArg = ScrcpyArg();

final _prefs = SharedPrefs();

late ObjectBox _objectBox;

void main() async {
  await init();
  await _prefs.initialize();
  _objectBox = await ObjectBox.create();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final _settings = AppSettings(_prefs);
  final _argsInstances = scrcpyArg.annotatedClasses
      .map((c) => c.newInstance('', []) as ScrcpyCliArgument)
      .toList(growable: false);
  late final _argsMap = {for (final instance in _argsInstances) instance.label: instance};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final platformBrightness = MediaQuery.of(context).platformBrightness;
      initTrayIcon(platformBrightness);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: WindowManager.instance.getSize(),
      builder: (context, asyncSnapshot) {
        if (!asyncSnapshot.hasData) {
          return SizedBox();
        }
        return MultiProvider(
          providers: [
            ...providers,
            Provider.value(value: _prefs),
            Provider.value(value: _settings),
            Provider.value(value: _objectBox),
            Provider.value(value: _argsInstances),
            Provider.value(value: asyncSnapshot.data!),
          ],
          child: StreamBuilder<Brightness?>(
            stream: _settings.themeBrightness,
            builder: (context, brightness) => FluentApp.router(
              debugShowCheckedModeBanner: false,
              title: 'scrcpy buddy 🤝',
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
                    BlocProvider(create: (_) => ProfilesBloc(_settings, _objectBox.profileBox, _argsMap)),
                    BlocProvider(create: (context) => ScrcpyBloc(context.read(), context.read(), context.read())),
                    BlocProvider(
                      create: (context) => DevicesBloc(context.read(), context.read(), _settings.adbExecutable),
                    ),
                    BlocProvider(create: (_) => SearchBloc(_argsInstances)),
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
      },
    );
  }
}
