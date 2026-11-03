# Quickshell Status Bar

A Tokyo Night–themed status bar for **Hyprland**, built with
[Quickshell](https://quickshell.org). One bar per monitor, with widgets grouped
left / center / right, plus an in-bar app menu.

## Layout

```
LEFT                  CENTER                           RIGHT
launcher · workspaces   updates · weather · clock      cpu-temp · cpu · ram · network · bluetooth · audio · power
```

## Structure

```
quickshell/.config/quickshell/
├── shell.qml            entry point — one Menu + one Bar per screen
├── bar/
│   ├── Bar.qml          the PanelWindow bar layout (left / center / right)
│   └── *Widget.qml      self-contained widgets
└── menu/
    └── Menu.qml         in-bar app launcher menu (search + list)
```

## Widgets

| Widget | Shows | Data source | Refresh |
|---|---|---|---|
| `LauncherWidget` | rofi drun app launcher | `~/.config/rofi/launchers/type-1/launcher.sh` on click | on click |
| `WorkspacesWidget` | occupied + active Hyprland workspaces (hover highlight) | `Quickshell.Hyprland` live model (event-driven) | instant |
| `UpdatesWidget` | number of outdated packages | `checkupdates \| wc -l` | 30 min |
| `WeatherWidget` | current weather + forecast popup | `wttr.in/Bologna,Italy?format=j1` | 30 min |
| `ClockWidget` | date + time | `date +%a %d %b - %H:%M` | 60 s |
| `CpuTempWidget` | CPU temperature | `x86_pkg`/`cpu` thermal zone | 3 s |
| `CpuUsageWidget` | CPU utilization | `top -bn1` idle field | 3 s |
| `RamWidget` | RAM used / percent | `free -m` | 3 s |
| `NetworkWidget` | default route source IP | `ip route get 1.1.1.1` | 10 s |
| `BluetoothWidget` | BT controller/connection state; opens `bluetui` | `bluetoothctl` + `kitty -e bluetui` | 5 s / on click |
| `AudioWidget` | volume %, mute toggle | `wpctl get-volume @DEFAULT_AUDIO_SINK@` | 2 s / on click |
| `PowerWidget` | rofi power menu | `~/.config/rofi/scripts/powermenu_t1` on click | on click |

## Running

This config lives at `~/.config/quickshell/` (a symlink to this directory), so it
is the **default** config — plain `quickshell` picks it up. It is launched from
`~/.config/hypr/hyprland.lua` via `hl.exec_cmd("quickshell")`.

Reload after editing (or let quickshell's file watcher reload automatically):

```sh
quickshell          # from a Wayland/Hyprland session
```

## Dependencies

- quickshell (>= 0.3.2)
- Hyprland (workspace widget uses `Quickshell.Hyprland`)
- rofi config under `~/.config/rofi` (launcher, powermenu)
- `checkupdates` (pacman-contrib) for the updates widget
- `bluetui` + `kitty` for the bluetooth widget
- `wpctl` (wireplumber / pipewire) for the audio widget
- `curl` + a network route for the weather and IP widgets

## Notes & remaining suggestions

- **NetworkWidget** prints the private source IP on the bar — remove/hide it if
  you don't want that exposed.
- **LauncherWidget** is now redundant with `menu/Menu.qml` — you can drop it from
  `Bar.qml` if you prefer the in-bar menu.
- On narrow screens the center row can overlap the side rows — add a minimum
  window width if that matters for your monitor layout.
