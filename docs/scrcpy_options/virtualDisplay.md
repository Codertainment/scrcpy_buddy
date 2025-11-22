### Virtual display options

| CLI option                   | Description (short)                                                                                     | Suggested GUI control                                     | Advanced? |
|------------------------------|---------------------------------------------------------------------------------------------------------|-----------------------------------------------------------|-----------|
| `--new-display`              | Create and mirror a virtual display instead of main screen; default size/density from main display. [1] | Switch/toggle “Use virtual display”                       | No        |
| `--new-display=WxH`          | Create virtual display with explicit width×height. [1]                                                  | Width/height number inputs (when virtual display enabled) | No        |
| `--new-display=WxH/DPI`      | Same as above but with explicit density. [1]                                                            | Additional DPI number input                               | Yes       |
| `--new-display=/DPI`         | Use main display size but explicit density. [1]                                                         | DPI number input (size fields disabled)                   | Yes       |
| `--no-vd-system-decorations` | Disable system decorations in virtual display (no launcher/system UI). [1]                              | Switch/toggle                                             | Yes       |
| `--no-vd-destroy-content`    | On closing scrcpy, move apps from virtual display back to main display instead of destroying them. [1]  | Switch/toggle                                             | Yes       |
| `--display-ime-policy=local` | Force IME (on‑screen keyboard) to appear on local display for given display/virtual display. [1]        | Dropdown (`default` / `local`) or checkbox “IME on local” | Yes       |
