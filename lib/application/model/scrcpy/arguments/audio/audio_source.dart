import 'package:scrcpy_buddy/application/model/scrcpy/scrcpy_cli_argument.dart';
import 'package:scrcpy_buddy/main.dart';

@scrcpyArg
class AudioSource extends ScrcpyCliArgument<String> {
  @override
  List<String> toArgs(String value) => [argument, value];

  @override
  final String argument = '--audio-source';

  @override
  final String label = 'audio.source';

  @override
  final List<String>? values = [
    'output',
    'playback',
    'mic',
    'mic-unprocessed',
    'mic-camcorder',
    'mic-voice-recognition',
    'mic-voice-communication',
    'voice-call',
    'voice-call-uplink',
    'voice-call-downlink',
    'voice-performance',
  ];
}
