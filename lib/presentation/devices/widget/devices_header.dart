import 'package:fluent_ui/fluent_ui.dart';
import 'package:scrcpy_buddy/presentation/extension/context_extension.dart';
import 'package:scrcpy_buddy/presentation/widgets/app_widgets.dart';

class DevicesHeader extends AppStatelessWidget {
  const DevicesHeader({super.key});

  @override
  String get module => 'devices';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Text(translatedText(context, key: 'header.device'), style: context.typography.caption),
          ),
          Expanded(
            flex: 3,
            child: Text(translatedText(context, key: 'header.status'), style: context.typography.caption),
          ),
          Expanded(
            flex: 3,
            child: Text(translatedText(context, key: 'header.serial'), style: context.typography.caption),
          ),
          Expanded(
            flex: 1,
            child: Text(
              translatedText(context, key: 'header.actions'),
              style: context.typography.caption,
              textAlign: TextAlign.end,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Color backgroundColor(Brightness brightness) {
    return brightness == Brightness.light ? Colors.grey[30] : Colors.grey[150];
  }

  Color separatorColor(Brightness brightness) {
    return brightness == Brightness.light ? Colors.grey[40] : Colors.grey[160];
  }
}
