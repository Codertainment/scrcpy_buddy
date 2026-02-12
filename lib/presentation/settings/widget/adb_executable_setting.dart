import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:scrcpy_buddy/application/app_settings.dart';
import 'package:scrcpy_buddy/application/extension/adb_error_extension.dart';
import 'package:scrcpy_buddy/presentation/devices/bloc/devices_bloc.dart';
import 'package:scrcpy_buddy/presentation/extension/translation_extension.dart';
import 'package:scrcpy_buddy/presentation/widgets/app_widgets.dart';
import 'package:scrcpy_buddy/service/adb_service.dart';

class AdbExecutableSetting extends StatefulWidget {
  const AdbExecutableSetting({super.key});

  @override
  State<AdbExecutableSetting> createState() => _AdbExecutableSettingState();
}

class _AdbExecutableSettingState extends AppModuleState<AdbExecutableSetting> {
  @override
  String get module => 'settings.adbExecutable';

  late final _executablePreference = context.read<AppSettings>().adbExecutable;
  late final _adbService = context.read<AdbService>();
  late final _devicesBloc = context.read<DevicesBloc>();

  final _infoFlyoutController = FlyoutController();
  final _textController = TextEditingController();
  bool _isSaving = false;
  bool _isCheckingVersionInfo = false;

  @override
  void initState() {
    super.initState();
    _textController.text = _executablePreference.getValue();
  }

  Future<void> _validateAndSave(String? path) async {
    if (path == null) return;
    if (path.isEmpty) {
      _setExecutablePath(path);
      return;
    }
    setState(() => _isSaving = true);
    final file = File(path);
    if (await file.exists()) {
      _setExecutablePath(path);
    } else {
      showInfoBar(
        title: translatedText(key: 'invalidPath'),
        severity: InfoBarSeverity.warning,
      );
    }
    setState(() => _isSaving = false);
  }

  Future<void> _setExecutablePath(String path) async {
    await _executablePreference.setValue(path);
    _devicesBloc.add(RestartTracking());
  }

  Future<void> _checkVersionInfo() async {
    setState(() => _isCheckingVersionInfo = true);
    final result = await _adbService.getVersionInfo(_textController.text);
    result.mapLeft((left) {
      if (kDebugMode) {
        print(left.toString());
      }
      showInfoBar(
        title: context.translatedText(key: 'common.somethingWentWrong'),
        content: left.message,
        severity: InfoBarSeverity.error,
      );
    });
    result.map((info) {
      _infoFlyoutController.showFlyout(
        builder: (context) {
          return FlyoutContent(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                WindowsIcon(FluentIcons.skype_circle_check, color: Colors.successPrimaryColor),
                const SizedBox(width: 8),
                Flexible(child: Text(info)),
              ],
            ),
          );
        },
      );
    });
    setState(() => _isCheckingVersionInfo = false);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextBox(
            controller: _textController,
            enabled: !_isSaving,
            textInputAction: TextInputAction.done,
            onSubmitted: (value) => _validateAndSave(value),
            onTapOutside: (_) => _validateAndSave(_textController.text),
            suffix: _isSaving
                ? ProgressRing()
                : IconButton(
                    icon: Icon(WindowsIcons.file_explorer),
                    onPressed: () async {
                      final result = await openFile();

                      if (result != null) {
                        _validateAndSave(result.path);
                      }
                    },
                  ),
          ),
        ),
        const SizedBox(width: 16),
        FlyoutTarget(
          controller: _infoFlyoutController,
          child: _isCheckingVersionInfo
              ? ProgressRing()
              : Button(
                  onPressed: _checkVersionInfo,
                  child: Text(translatedText(key: 'check')),
                ),
        ),
      ],
    );
  }
}
