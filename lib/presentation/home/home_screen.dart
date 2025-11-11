import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:scrcpy_buddy/application/args_bloc/args_bloc.dart';
import 'package:scrcpy_buddy/application/scrcpy_bloc/scrcpy_bloc.dart';
import 'package:scrcpy_buddy/presentation/extension/translation_extension.dart';
import 'package:scrcpy_buddy/presentation/home/widgets/start_button.dart';
import 'package:scrcpy_buddy/presentation/widgets/app_widgets.dart';
import 'package:scrcpy_buddy/routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.child});

  final Widget child;

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

  final _devicesKey = ValueKey('/devices');
  final _settingsKey = ValueKey('/settings');

  void _openRoute(String path) {
    if (GoRouterState.of(context).uri.toString() != path) {
      context.push(path);
    }
  }

  Text _buildPaneItemTitle(BuildContext context, String labelKey) =>
      Text(context.translatedText(key: 'home.navigation.$labelKey'));

  List<NavigationPaneItem> _getMainItems(BuildContext context) => [
    PaneItem(
      key: _devicesKey,
      icon: WindowsIcon(WindowsIcons.cell_phone),
      title: _buildPaneItemTitle(context, 'devices'),
      body: const SizedBox.shrink(),
      onTap: () => _openRoute(AppRoute.devices),
    ),
  ];

  List<NavigationPaneItem> _getFooterItems(BuildContext context) => [
    PaneItem(
      key: _settingsKey,
      icon: const WindowsIcon(WindowsIcons.settings),
      title: _buildPaneItemTitle(context, 'settings'),
      body: const SizedBox.shrink(),
      onTap: () => _openRoute(AppRoute.settings),
    ),
  ];

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    int indexOriginal = _getMainItems(
      context,
    ).where((item) => item.key != null).toList().indexWhere((item) => item.key == Key(location));

    if (indexOriginal == -1) {
      int indexFooter = _getFooterItems(
        context,
      ).where((element) => element.key != null).toList().indexWhere((element) => element.key == Key(location));
      if (indexFooter == -1) {
        return 0;
      }
      return _getMainItems(context).where((element) => element.key != null).toList().length + indexFooter;
    } else {
      return indexOriginal;
    }
  }

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      paneBodyBuilder: (_, _) => widget.child,
      pane: NavigationPane(
        displayMode: PaneDisplayMode.compact,
        items: _getMainItems(context),
        selected: _calculateSelectedIndex(context),
        footerItems: _getFooterItems(context),
      ),
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
