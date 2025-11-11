import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:scrcpy_buddy/application/args_bloc/args_bloc.dart';
import 'package:scrcpy_buddy/application/model/scrcpy/scrcpy_arg.dart';
import 'package:scrcpy_buddy/application/scrcpy_bloc/scrcpy_bloc.dart';
import 'package:scrcpy_buddy/main.reflectable.dart';
import 'package:scrcpy_buddy/presentation/devices/bloc/devices_bloc.dart';
import 'package:scrcpy_buddy/presentation/home/home_screen.dart';
import 'package:system_theme/system_theme.dart';

import 'injector.dart';

const scrcpyArg = ScrcpyArg();

void main() async {
  initializeReflectable();
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
        debugShowCheckedModeBanner: false,
        title: 'scrcpy Buddy',
        themeMode: ThemeMode.system,
        theme: FluentThemeData(accentColor: SystemTheme.accentColor.accent.toAccentColor()),
        darkTheme: FluentThemeData(
          brightness: Brightness.dark,
          accentColor: SystemTheme.accentColor.accent.toAccentColor(),
        ),
        home: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => ArgsBloc()),
            BlocProvider(create: (context) => ScrcpyBloc(context.read(), context.read())),
            BlocProvider(create: (context) => DevicesBloc(context.read())),
          ],
          child: HomeScreen(),
        ),
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
