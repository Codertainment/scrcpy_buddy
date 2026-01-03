import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:scrcpy_buddy/application/app_settings.dart';
import 'package:scrcpy_buddy/application/extension/scrcpy_error_extension.dart';
import 'package:scrcpy_buddy/presentation/extension/translation_extension.dart';
import 'package:scrcpy_buddy/presentation/widgets/app_widgets.dart';
import 'package:scrcpy_buddy/service/scrcpy_service.dart';

class ScrcpyExecutableSetting extends StatefulWidget {
  const ScrcpyExecutableSetting({super.key});

  @override
  State<ScrcpyExecutableSetting> createState() => _ScrcpyExecutableSettingState();
}

class _ScrcpyExecutableSettingState extends AppModuleState<ScrcpyExecutableSetting> {
  @override
  String get module => 'settings.scrcpyExecutable';

  late final _executablePreference = context.read<AppSettings>().scrcpyExecutable;
  late final _scrcpyService = context.read<ScrcpyService>();

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
      await _executablePreference.setValue(path);
      return;
    }
    setState(() => _isSaving = true);
    final file = File(path);
    if (await file.exists()) {
      await _executablePreference.setValue(path);
    } else {
      showInfoBar(
        title: translatedText(key: 'invalidPath'),
        severity: InfoBarSeverity.warning,
      );
    }
    setState(() => _isSaving = false);
  }

  Future<void> _checkVersionInfo() async {
    setState(() => _isCheckingVersionInfo = true);
    final result = await _scrcpyService.getVersionInfo(_textController.text);
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
