# Window options

| CLI option              | Description (short)                                                              | Suggested GUI control              | Advanced? |
|-------------------------|----------------------------------------------------------------------------------|------------------------------------|-----------|
| `--always-on-top`       | Keep the window always on top of other windows.                                  | Switch/toggle                      | No        |
| `--fullscreen` / `-f`   | Start scrcpy directly in fullscreen mode.                                        | Switch/toggle                      | No        |
| `--no-window`           | Disable window completely (useful for audio‑only or headless recording/control). | Switch/toggle “Run without window” | No        |
| `--window-title`        | Custom window title instead of device model.                                     | Text input                         | No        |
| `--window-x`            | Initial window X position in pixels.                                             | Number input (px)                  | Yes       |
| `--window-y`            | Initial window Y position in pixels.                                             | Number input (px)                  | Yes       |
| `--window-width`        | Initial window width in pixels.                                                  | Number input (px)                  | Yes       |
| `--window-height`       | Initial window height in pixels.                                                 | Number input (px)                  | Yes       |
| `--window-borderless`   | Disable window decorations (no border, no title bar).                            | Switch/toggle                      | Yes       |
| `--disable-screensaver` | Prevent the computer screensaver while scrcpy is running.                        | Switch/toggle                      | Yes       |
