import 'package:fluent_ui/fluent_ui.dart';
import 'package:scrcpy_buddy/presentation/widgets/app_widgets.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends AppModuleState<VideoScreen> {
  @override
  String get module => 'config.video';

  @override
  Widget build(BuildContext context) {
    return Text(translatedText(key: 'title'));
  }
}
