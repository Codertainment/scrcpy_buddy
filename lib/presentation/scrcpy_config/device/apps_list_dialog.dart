import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:scrcpy_buddy/application/model/scrcpy/device_app.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/widgets/config_text_box.dart';
import 'package:scrcpy_buddy/presentation/widgets/app_widgets.dart';

class AppsListDialog extends StatefulWidget {
  final List<DeviceApp> apps;

  const AppsListDialog({super.key, required this.apps});

  @override
  State<AppsListDialog> createState() => _AppsListDialogState();
}

class _AppsListDialogState extends AppModuleState<AppsListDialog> {
  @override
  String get module => 'config.device.appsList';

  String? _searchTerm;
  bool _onlySystemApps = false;
  bool _onlyThirdPartyApps = false;

  void _onOnlySystemAppsFilterChanged([bool? newValue]) =>
      setState(() => _onlySystemApps = newValue ?? !_onlySystemApps);

  void _onOnlyThirdPartyAppsFilterChanged([bool? newValue]) =>
      setState(() => _onlyThirdPartyApps = newValue ?? !_onlyThirdPartyApps);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ConfigTextBox(
                prefix: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: WindowsIcon(WindowsIcons.search, size: 12),
                ),
                maxWidth: double.maxFinite,
                value: _searchTerm,
                placeholder: translatedText(key: 'search'),
                onChanged: (value) => setState(() => _searchTerm = value?.trim()),
              ),
            ),
            const SizedBox(width: 16),
            DropDownButton(
              leading: WindowsIcon(WindowsIcons.filter),
              title: Text(translatedText(key: 'filter')),
              items: [
                MenuFlyoutItem(
                  text: Text(translatedText(key: 'onlySystemApps')),
                  leading: Checkbox(checked: _onlySystemApps, onChanged: _onOnlySystemAppsFilterChanged),
                  onPressed: () => _onOnlySystemAppsFilterChanged(),
                ),
                MenuFlyoutItem(
                  text: Text(translatedText(key: 'onlyThirdPartyApps')),
                  leading: Checkbox(checked: _onlyThirdPartyApps, onChanged: _onOnlyThirdPartyAppsFilterChanged),
                  onPressed: () => _onOnlyThirdPartyAppsFilterChanged(),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView(
            shrinkWrap: true,
            children: widget.apps
                .where((app) => _isSearchMatch(app) && _isFilterMatch(app))
                .map(
                  (app) => ListTile(
                    leading: app.isSystem
                        ? Tooltip(
                            message: translatedText(key: 'iconTooltip.system'),
                            child: WindowsIcon(WindowsIcons.application_guard),
                          )
                        : Tooltip(
                            message: translatedText(key: 'iconTooltip.thirdParty'),
                            child: WindowsIcon(WindowsIcons.download),
                          ),
                    title: Text(app.name),
                    subtitle: Text(app.package),
                    onPressed: () => context.pop(app.package),
                  ),
                )
                .toList(growable: false),
          ),
        ),
      ],
    );
  }

  bool _isSearchMatch(DeviceApp app) {
    if (_searchTerm?.isNotEmpty == true) {
      return app.name.toLowerCase().contains(_searchTerm!.toLowerCase()) ||
          app.package.contains(_searchTerm!.toLowerCase());
    } else {
      return true;
    }
  }

  bool _isFilterMatch(DeviceApp app) {
    if (_onlySystemApps) {
      return app.isSystem;
    } else if (_onlyThirdPartyApps) {
      return !app.isSystem;
    } else {
      return true;
    }
  }
}
