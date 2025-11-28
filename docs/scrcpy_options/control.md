# Control options

| CLI option                | Description (short)                                                                         | Suggested GUI control             | Advanced? |
|---------------------------|---------------------------------------------------------------------------------------------|-----------------------------------|-----------|
| `--no-control` / `-n`     | Disable all control (no input events, no drag & drop); read‑only mirroring.                 | Switch/toggle “Read‑only mode”    | No        |
| `--no-clipboard-autosync` | Disable automatic Android↔computer clipboard synchronization.                               | Switch/toggle                     | Yes       |
| `--legacy-paste`          | Change Ctrl+v / MOD+v to inject clipboard text as key events (for buggy clipboard devices). | Switch/toggle “Legacy paste mode” | Yes       |

### Gestures

Also add a section to explain the touch simulation gestures: pinch-to-zoom, rotate and tilt
https://github.com/Genymobile/scrcpy/blob/master/doc/control.md#pinch-to-zoom-rotate-and-tilt-simulation

### File drop

Explain about drag and drop
Add the following config:

| CLI option      | Description (short)                                                                       | Suggested GUI control                  | Advanced? |
|-----------------|-------------------------------------------------------------------------------------------|----------------------------------------|-----------|
| `--push-target` | Directory on device where non‑APK dragged files are pushed (default `/sdcard/Download/`). | Text input with folder‑picker style UX | No        |

***

## Keyboard options

| CLI option         | Description (short)                                                                                    | Suggested GUI control | Advanced? |
|--------------------|--------------------------------------------------------------------------------------------------------|-----------------------|-----------|
| `--keyboard`       | Select keyboard mode: `sdk` (default), `uhid`, `aoa`, `disabled`.                                      | Dropdown              | No        |
| `--prefer-text`    | Prefer injecting letters as text events instead of key events (better compatibility, worse for games). | Switch/toggle         | Yes       |
| `--raw-key-events` | Inject everything as raw key events (no text events).                                                  | Switch/toggle         | Yes       |
| `--no-key-repeat`  | Disable key repeat when holding a key down (avoid performance issues in some games).                   | Switch/toggle         | Yes       |

***

## Mouse options

| CLI option         | Description (short)                                                                                  | Suggested GUI control                            | Advanced? |
|--------------------|------------------------------------------------------------------------------------------------------|--------------------------------------------------|-----------|
| `--mouse`          | Select mouse mode: `sdk` (default), `uhid`, `aoa`, `disabled`.                                       | Dropdown                                         | No        |
| `--no-mouse-hover` | Do not forward mouse move/hover events without click to the device.                                  | Switch/toggle                                    | Yes       |
| `--mouse-bind`     | Configure bindings for right/middle/4th/5th clicks and their Shift variants (`b/h/s/n/+/-` pattern). | Advanced text input with helper (binding editor) | Yes       |

***

## Gamepad options

| CLI option  | Description (short)                                          | Suggested GUI control | Advanced? |
|-------------|--------------------------------------------------------------|-----------------------|-----------|
| `--gamepad` | Select gamepad mode: `uhid`, `aoa`, `disabled` (no gamepad). | Dropdown              | No        |
