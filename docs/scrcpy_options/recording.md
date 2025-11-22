# Recording options

| CLI option            | Description (short)                                                                              | Suggested GUI control                            | Advanced? |
|-----------------------|--------------------------------------------------------------------------------------------------|--------------------------------------------------|-----------|
| `--record` / `-r`     | Record streams to a file; container is inferred from extension. [1]                              | File picker (path + extension)                   | No        |
| `--record-format`     | Explicitly set container (`mp4`, `mkv`, `opus`, `flac`, `wav`) regardless of filename extension. | Dropdown                                         | Yes       |
| `--time-limit`        | Limit mirroring/recording duration in seconds.                                                   | Number input (seconds)                           | Yes       |
| `--no-playback`       | Disable both video and audio playback while still recording/forwarding.                          | Switch/toggle “Record only (no live playback)”   | Yes       |
| `--no-video-playback` | Record both video and audio but do not show local video playback.                                | Switch/toggle “Hide video while recording”       | Yes       |
| `--no-audio-playback` | Record both video and audio but do not play audio locally.                                       | Switch/toggle “Mute local audio while recording” | Yes       |
| `--no-window`         | Record without window (headless); usually combined with `--no-playback`.                         | Switch/toggle (already in Window category)       | Yes       |
