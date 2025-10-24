import 'package:fluent_ui/fluent_ui.dart';
import 'package:scrcpy_buddy/presentation/devices/devices_widget.dart';
import 'package:scrcpy_buddy/presentation/widgets/app_widgets.dart';

class HomeScreen extends AppStatelessWidget {
  const HomeScreen({super.key});

  @override
  String get module => 'home';

  List<NavigationPaneItem> getItems(BuildContext context) => [
    PaneItem(
      icon: WindowsIcon(WindowsIcons.cell_phone),
      title: Text(translatedText(context, key: 'navigation.devices')),
      body: DevicesScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final typography = FluentTheme.of(context).typography;
    return NavigationView(
      appBar: NavigationAppBar(title: Text('scrcpy buddy', style: typography.title)),
      pane: NavigationPane(items: getItems(context)),
    );
  }
}
