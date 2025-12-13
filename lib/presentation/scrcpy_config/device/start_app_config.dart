import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:scrcpy_buddy/application/app_settings.dart';
import 'package:scrcpy_buddy/application/extension/adb_device_extension.dart';
import 'package:scrcpy_buddy/application/extension/scrcpy_error_extension.dart';
import 'package:scrcpy_buddy/application/model/scrcpy/arguments/device/start_app.dart';
import 'package:scrcpy_buddy/application/model/scrcpy/device_app.dart';
import 'package:scrcpy_buddy/application/model/scrcpy/scrcpy_arg.dart';
import 'package:scrcpy_buddy/application/profiles_bloc/profiles_bloc.dart';
import 'package:scrcpy_buddy/presentation/devices/bloc/devices_bloc.dart';
import 'package:scrcpy_buddy/presentation/extension/context_extension.dart';
import 'package:scrcpy_buddy/presentation/extension/translation_extension.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/device/apps_list_dialog.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/widgets/config_text_box.dart';
import 'package:scrcpy_buddy/presentation/widgets/app_widgets.dart';
import 'package:scrcpy_buddy/service/scrcpy_service.dart';

class StartAppConfig extends StatefulWidget {
  const StartAppConfig({super.key});

  @override
  State<StartAppConfig> createState() => _StartAppConfigState();
}

class _StartAppConfigState extends AppModuleState<StartAppConfig> {
  @override
  String get module => 'config.device.startApp';

  late final _appSettings = context.read<AppSettings>();
  late final _profilesBloc = context.read<ProfilesBloc>();

  final _startApp = StartApp();

  bool _appsListLoading = false;

  Future<void> _loadApps(String deviceSerial) async {
    setState(() => _appsListLoading = true);
    final result = await context.read<ScrcpyService>().listApps(deviceSerial, _appSettings.scrcpyExecutable.getValue());
    result.mapLeft(
      (error) => showInfoBar(
        title: translatedText(key: 'listAppsError'),
        content: error.message,
      ),
    );
    result.map(_showAppPicker);
    setState(() => _appsListLoading = false);
  }

  Future<void> _showAppPicker(List<DeviceApp> apps) async {
    final selectedApp = await showDialog(
      context: context,
      builder: (context) => ContentDialog(
        title: Row(
          children: [
            Text(translatedText(key: 'dialogTitle')),
            const Spacer(),
            Tooltip(
              message: context.translatedText(key: 'common.close'),
              child: IconButton(icon: WindowsIcon(WindowsIcons.clear), onPressed: () => context.pop()),
            ),
          ],
        ),
        content: AppsListDialog(apps: apps),
      ),
    );
    if (selectedApp != null) {
      _profilesBloc.add(UpdateProfileArgEvent(_startApp, selectedApp));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DevicesBloc, DevicesState>(
      builder: (context, devicesState) {
        return Column(
          crossAxisAlignment: .end,
          children: [
            ConfigTextBox(
              maxWidth: context.windowSize.width * 0.2,
              value: _profilesBloc.state.getFor(_startApp),
              onChanged: (newValue) => _profilesBloc.add(UpdateProfileArgEvent(_startApp, newValue)),
            ),
            if (devicesState is DevicesBaseUpdateState) ...[
              const SizedBox(height: 16),
              if (_appsListLoading) ...[
                const ProgressRing(),
              ] else
                DropDownButton(
                  title: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(translatedText(key: 'selectApp')),
                  ),
                  items: devicesState.devices
                      .where((device) => device.isReady)
                      .map(
                        (device) => MenuFlyoutItem(
                          text: Text(device.model ?? device.codename ?? context.translatedText(key: 'devices.unknown')),
                          onPressed: () => _loadApps(device.serial),
                        ),
                      )
                      .toList(growable: false),
                ),
            ],
          ],
        );
      },
    );
  }
}
