import 'package:fluent_ui/fluent_ui.dart';
import 'package:scrcpy_buddy/presentation/devices/devices_widget.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<NavigationPaneItem> items = [
    PaneItem(icon: WindowsIcon(WindowsIcons.cell_phone), title: Text("Devices"), body: DevicesScreen()),
  ];

  @override
  Widget build(BuildContext context) {
    final typography = FluentTheme.of(context).typography;
    return NavigationView(
      appBar: NavigationAppBar(title: Text('scrcpy buddy', style: typography.title)),
      pane: NavigationPane(items: items),
    );
  }
}
