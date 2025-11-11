import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrcpy_buddy/application/args_bloc/args_bloc.dart';
import 'package:scrcpy_buddy/application/scrcpy_bloc/scrcpy_bloc.dart';
import 'package:scrcpy_buddy/presentation/devices/devices_screen.dart';
import 'package:scrcpy_buddy/presentation/home/widgets/start_button.dart';
import 'package:scrcpy_buddy/presentation/widgets/app_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends AppModuleState<HomeScreen> {
  late final _scrcpyBloc = context.read<ScrcpyBloc>();
  late final _argsBloc = context.read<ArgsBloc>();

  @override
  void initState() {
    super.initState();
    _argsBloc.add(InitializeArgsEvent());
  }

  @override
  String get module => 'home';

  List<NavigationPaneItem> getItems(BuildContext context) => [
    PaneItem(
      icon: WindowsIcon(WindowsIcons.cell_phone),
      title: Text(translatedText(key: 'navigation.devices')),
      body: DevicesScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      pane: NavigationPane(displayMode: PaneDisplayMode.compact, items: getItems(context)),
      appBar: NavigationAppBar(
        title: Text('scrcpy buddy', style: typography.title),
        actions: Padding(
          padding: const EdgeInsets.only(top: 12, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [StartButton(argsBloc: _argsBloc, scrcpyBloc: _scrcpyBloc)],
          ),
        ),
      ),
    );
  }
}
