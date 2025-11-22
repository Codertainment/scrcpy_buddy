# Video options

| CLI option                | Description (short)                                                                 | Suggested GUI control                              | Advanced? |
|---------------------------|-------------------------------------------------------------------------------------|----------------------------------------------------|-----------|
| `--max-size` / `-m`       | Limit both width and height to a maximum value, preserving aspect ratio. [1][1]     | Number input (pixels)                              | No        |
| `--video-bit-rate` / `-b` | Set video bit rate (e.g. 2M, 8000000). [1]                                          | Number input + unit dropdown (kbps/Mbps)           | No        |
| `--max-fps`               | Limit capture frame rate. [1]                                                       | Number input (fps)                                 | No        |
| `--video-codec`           | Select codec: h264 (default), h265, av1. [1][1]                                     | Dropdown                                           | No        |
| `--no-video`              | Disable video forwarding completely (audio-only session). [1]                       | Switch/toggle (also surfaced under “Session mode”) | No        |
| `--no-downsize-on-error`  | Do not retry encoding with a lower resolution if the first attempt fails. [1]       | Switch/toggle                                      | Yes       |
| `--print-fps`             | Print actual capture FPS periodically to console. [1]                               | Switch/toggle (logging / diagnostics)              | Yes       |
| `--video-codec-options`   | Pass arbitrary `MediaFormat` parameters to the video encoder. [1]                   | Text input (key=value,key2=value2)                 | Yes       |
| `--video-encoder`         | Force use of a specific video encoder implementation. [1]                           | Text input or dropdown (if you query encoders)     | Yes       |
| `--capture-orientation`   | Server-side transform/lock of captured video orientation (affects recording). [1]   | Dropdown with presets + “lock” checkbox            | Yes       |
| `--orientation`           | Client-side orientation for both display and recording. [1]                         | Dropdown                                           | Yes       |
| `--display-orientation`   | Orientation applied only to display (window). [1]                                   | Dropdown                                           | Yes       |
| `--record-orientation`    | Orientation applied only to the recorded file. [1]                                  | Dropdown                                           | Yes       |
| `--angle`                 | Arbitrary additional rotation angle (degrees, clockwise). [1]                       | Number input (0–359)                               | Yes       |
| `--crop`                  | Crop to rectangle `width:height:x:y` in device natural orientation. [1]             | 4-number composite input or “custom crop” dialog   | Yes       |
| `--display-id`            | Select which Android display to mirror (for multi-display devices). [1]             | Dropdown populated from “List displays” action     | Yes       |
| `--video-buffer`          | Add buffering for video playback in ms to smooth jitter. [1]                        | Number input (ms)                                  | Yes       |
| `--v4l2-buffer`           | Set buffering for V4L2 video sink in ms. [1]                                        | Number input (ms)                                  | Yes       |
| `--no-playback`           | Disable both video and audio playback on the computer (still capture/record). [1]   | Switch/toggle                                      | Yes       |
| `--no-video-playback`     | Disable only video playback (e.g. send to V4L2 but do not show windowed video). [1] | Switch/toggle                                      | Yes       |
| `--no-downsize-on-error`  | Do not retry encoding with a lower resolution if the first attempt fails. [1]       | Switch/toggle                                      | Yes       |
