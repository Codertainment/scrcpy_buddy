import 'package:fluent_ui/fluent_ui.dart';
import 'package:scrcpy_buddy/application/scrcpy_bloc/scrcpy_bloc.dart';
import 'package:scrcpy_buddy/presentation/extension/context_extension.dart';
import 'package:scrcpy_buddy/presentation/home/console_section/widgets/code_view.dart';
import 'package:scrcpy_buddy/presentation/widgets/app_widgets.dart';

class ConsoleDialog extends AppStatelessWidget {
  final ScrcpyStopSuccessState state;

  const ConsoleDialog({super.key, required this.state});

  @override
  String get module => 'home.error.scrcpy.unexpectedStop.console';

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: Row(
        children: [
          Expanded(
            child: Text(
              translatedText(context, key: 'title', translationParams: {'deviceSerial': state.deviceSerial}),
              style: context.typography.subtitle,
            ),
          ),
          const SizedBox(width: 16),
          IconButton(icon: WindowsIcon(WindowsIcons.clear), onPressed: () => Navigator.pop(context)),
        ],
      ),
      content: SingleChildScrollView(child: CodeView(lines: state.stdLines ?? [], fontSize: 13)),
    );
  }
}
