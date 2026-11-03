# AGENTS.md

Guidance for AI agents and contributors working on this Quickshell status bar.

## Project shape

- **Entry point:** `shell.qml` at the config root. Quickshell auto-detects it as
  the `default` config at `~/.config/quickshell/shell.qml` (this directory is
  symlinked there). There is **no** `main.qml` — do not create one.
- **Bar layout:** `bar/Bar.qml`, a `PanelWindow` with left / center / right rows.
  It instantiates the widget files from `bar/`. One `Bar` and one `Menu` are
  created per screen (`Variants` over `Quickshell.screens` in `shell.qml`).
- **Widgets:** one self-contained QML file per widget in `bar/`. Each is a small
  `Item`/`Row`/`Text` tree plus a `Quickshell.Io.Process` (and optional `Timer`)
  for data.
- **Menu:** `menu/Menu.qml` — an in-bar app launcher (search + list).

## Conventions

- **Palette** (Tokyo Night): text `#c0caf5`, inactive `#545c7e`, accent blue
  `#7aa2f7`, green `#9ece6a`, red `#f7768e`, orange `#ff9e64`, gold `#e0af68`,
  background `#1a1b26`. Keep widgets on-palette.
- **Data pattern:** `Process { command: [...]; running: true; stdout:
  StdioCollector { onStreamFinished: ... } }` plus a repeating `Timer` to
  re-trigger `running = true`. Prefer shell commands that are cheap and reliable.
- **Icons** are Nerd Font glyphs in the bar's font — verify a glyph actually
  exists in the installed nerd font before changing one.
- **Rename a widget file** → you must update its use in `Bar.qml` too.

## Pitfalls (learned while editing this repo)

- **`PanelWindow.anchors` are layer-shell booleans** (`top`, `left`, `right`,
  `bottom`), **not** Qt Quick anchors. Do not anchor children to `parent.left`
  etc. on the window itself — use `Item.anchors` inside it, and `PanelWindow.margins`
  (a `{ top, left, ... }` block) to offset from screen edges.
- **Always set `exclusiveZone`** on a top/bottom bar (at least bar height), or
  maximized windows slide underneath it.
- **`focusable: true`** is required for a popup `PanelWindow` to receive keyboard
  focus (e.g. ESC-to-close via `Keys.onEscapePressed`). Default is `false`.
- **Prefer `Quickshell.Hyprland`** (`Hyprland.workspaces`, `Hyprland.monitorFor`,
  `workspace.activate()`) over polling `hyprctl`. It's event-driven and cheap.
- **Verify referenced external scripts exist** before wiring them into a
  `Process` — two widgets previously pointed at scripts that were missing or
  uninstalled (`toggle_launcher.sh`, `waybar-module-pacman-updates`).
- `checkupdates` (pacman-contrib) is installed here for the updates widget;
  `~/.config/rofi/launchers/type-1/launcher.sh` and
  `~/.config/rofi/scripts/powermenu_t1` are the real rofi entry points.
- Hyprland workspace **ids can be non-contiguous** — treat `Hyprland.workspaces`
  as an ordered list, never an id-indexed array.

## Verify before committing

```sh
cd ~/dotfiles/quickshell/.config/quickshell
for f in $(find . -name '*.qml'); do qmllint "$f"; done   # no errors expected
```

## Git workflow

- Repo: `~/dotfiles` → GitHub `CaffeLatteIV/dotfiles`.
- **Always `git add` + `git commit` + `git push`** after finishing a change.
- This config was recently restructured into `bar/` + `menu/` subdirectories — if
  you move files again, keep `shell.qml` importing `./bar` and `./menu`, and keep
  the symlink target in sync.
