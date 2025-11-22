# Device options

| CLI option                 | Description (short)                                                                          | Suggested GUI control                      | Advanced? |
|----------------------------|----------------------------------------------------------------------------------------------|--------------------------------------------|-----------|
| `--stay-awake` / `-w`      | Keep device awake while plugged in; restore previous value on exit. [1]                      | Switch/toggle                              | No        |
| `--turn-screen-off` / `-S` | Turn device screen off immediately on start; can be toggled back via shortcut.               | Switch/toggle “Start with screen off”      | No        |
| `--show-touches` / `-t`    | Enable “show touches” developer option while running; restore on exit.                       | Switch/toggle                              | No        |
| `--start-app=PKG`          | Start given app (by package) on start; supports `+` force‑stop and `?` name search prefixes. | Text input with app picker & flags (+ / ?) | No        |
| `--screen-off-timeout`     | Override Android screen‑off timeout (seconds) while running; restore on exit.                | Number input (seconds)                     | Yes       |
| `--power-off-on-close`     | Turn device screen off when scrcpy exits.                                                    | Switch/toggle                              | Yes       |
| `--no-power-on`            | Do not automatically power on / wake device on start.                                        | Switch/toggle                              | Yes       |
| `--list-apps`              | List installed apps on the device (for use with `--start-app`).                              | Button “List apps…” (opens chooser UI)     | Yes       |
