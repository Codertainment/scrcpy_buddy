# Audio options

| CLI option              | Description (short)                                                                                     | Suggested GUI control                                  | Advanced? |
|-------------------------|---------------------------------------------------------------------------------------------------------|--------------------------------------------------------|-----------|
| `--no-audio`            | Disable audio forwarding completely. [1]                                                                | Switch/toggle                                          | No        |
| `--audio-source`        | Select audio source: `output` (default), `playback`, many `mic-*` and `voice-*` variants.               | Dropdown with groups (Output / Playback / Mic / Voice) | No        |
| `--audio-codec`         | Select audio codec: `opus` (default), `aac`, `flac`, `raw`.                                             | Dropdown                                               | No        |
| `--require-audio`       | Make scrcpy fail if audio is not available, instead of falling back to video-only.                      | Switch/toggle                                          | Yes       |
| `--no-audio-playback`   | Do not play audio locally, while still forwarding/recording it.                                         | Switch/toggle                                          | Yes       |
| `--no-window`           | Run without any window; implies no video and no control (audio-only/headless).                          | Switch/toggle (in “Headless / server mode”)            | Yes       |
| `--audio-dup`           | With `playback` capture method, keep audio playing on device while also forwarding to PC (Android 13+). | Switch/toggle                                          | Yes       |
| `--audio-codec-options` | Extra `MediaFormat` parameters for audio encoder, e.g. FLAC compression level.                          | Text input (key=value,key2=value2)                     | Yes       |
| `--audio-encoder`       | Force use of a specific audio encoder implementation.                                                   | Text input or dropdown (if you query encoders)         | Yes       |
| `--audio-bit-rate`      | Audio bitrate (e.g. 128K, 64000); not used for `raw` codec.                                             | Number input + unit dropdown                           | Yes       |
| `--audio-buffer`        | Main audio buffer target size in ms; trade latency vs glitches.                                         | Number input (ms)                                      | Yes       |
| `--audio-output-buffer` | Additional audio output buffer (default 5ms); only adjust if sound is glitchy/robotic.                  | Number input (ms)                                      | Yes       |
