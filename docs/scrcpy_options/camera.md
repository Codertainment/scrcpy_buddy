# Camera options

Camera mirroring is supported for devices with Android 12 or higher.

| CLI option            | Description (short)                                                                         | Suggested GUI control                             | Advanced? |
|-----------------------|---------------------------------------------------------------------------------------------|---------------------------------------------------|-----------|
| `--camera-id`         | Use a specific camera id from `--list-cameras`. [4]                                         | Dropdown / number input                           | No        |
| `--camera-facing`     | Auto‑select first camera by facing: `front`, `back`, `external`. [4]                        | Dropdown                                          | No        |
| `--list-cameras`      | List available cameras with their ids. [4]                                                  | Button “List cameras…” (populate camera dropdown) | Yes       |
| `--list-camera-sizes` | List declared valid camera sizes and frame rates. [4]                                       | Button in advanced camera settings panel          | Yes       |
| `--camera-size`       | Explicit camera resolution (e.g. `1920x1080`); excludes `--max-size` and `--camera-ar`. [4] | Width/height number inputs                        | Yes       |
| `--camera-ar`         | Aspect ratio constraint for auto size selection: `<num>:<den>`, float, or `sensor`. [4]     | Text input or dropdown of common ratios           | Yes       |
| `--camera-fps`        | Target camera capture frame rate (e.g. 60, 120, 240). [4]                                   | Number input (fps)                                | Yes       |
