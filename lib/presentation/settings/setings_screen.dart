import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:scrcpy_buddy/application/app_settings.dart';
import 'package:scrcpy_buddy/application/extension/scrcpy_error_extension.dart';
import 'package:scrcpy_buddy/presentation/extension/translation_extension.dart';
import 'package:scrcpy_buddy/presentation/widgets/app_widgets.dart';
import 'package:scrcpy_buddy/service/scrcpy_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends AppModuleState<SettingsScreen> {
  @override
  String get module => 'settings';

  late final _settings = context.read<AppSettings>();
  late final _scrcpyService = context.read<ScrcpyService>();

  final _infoFlyoutController = FlyoutController();
  final _scrcpyExecutableController = TextEditingController();
  bool _isSavingScrcpyExecutable = false;
  bool _isCheckingVersionInfo = false;

  @override
  void initState() {
    super.initState();
    _scrcpyExecutableController.text = _settings.scrcpyExecutable.getValue();
  }

  Future<void> _validateAndSave(String? path) async {
    if (path == null) return;
    setState(() => _isSavingScrcpyExecutable = true);
    final file = File(path);
    if (await file.exists()) {
      await _settings.scrcpyExecutable.setValue(path);
    } else {
      showInfoBar(
        title: translatedText(key: 'scrcpyExecutable.invalidPath'),
        severity: InfoBarSeverity.warning,
      );
    }
    setState(() => _isSavingScrcpyExecutable = false);
  }

  Future<void> _checkVersionInfo() async {
    setState(() => _isCheckingVersionInfo = true);
    final result = await _scrcpyService.getVersionInfo(_scrcpyExecutableController.text);
    result.mapLeft(
      (left) => showInfoBar(
        title: context.translatedText(key: 'common.somethingWentWrong'),
        content: left.message,
        severity: InfoBarSeverity.error,
      ),
    );
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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(translatedText(key: 'scrcpyExecutable.title'), style: typography.bodyStrong),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 600),
            child: Row(
              children: [
                Expanded(
                  child: TextBox(
                    controller: _scrcpyExecutableController,
                    enabled: !_isSavingScrcpyExecutable,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (value) => _validateAndSave(value),
                    onTapOutside: (_) => _validateAndSave(_scrcpyExecutableController.text),
                    suffix: _isSavingScrcpyExecutable
                        ? ProgressRing()
                        : IconButton(
                            icon: Icon(WindowsIcons.file_explorer),
                            onPressed: () async {
                              final result = await FilePicker.platform.pickFiles(
                                dialogTitle: translatedText(key: 'scrcpyExecutable.dialogTitle'),
                              );

                              if (result != null) {
                                _validateAndSave(result.files.single.path);
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
                          child: Text(translatedText(key: 'scrcpyExecutable.check')),
                        ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(translatedText(key: 'scrcpyExecutable.description'), style: typography.caption),
        ],
      ),
    );
  }
}
