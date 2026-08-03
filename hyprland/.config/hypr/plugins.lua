---@module 'hl'

local home = os.getenv("HOME")

package.path = package.path .. ";" .. home .. "/.config/hypr/plugins/split-monitor-workspaces/lua/?.lua"

--- Import the library.
local smw = require("split-monitor-workspaces")

--- Required setup call with your custom configuration.
smw.setup({
	--- Number of workspaces assigned to each monitor.
	workspace_count = 10,

	--- Monitor priority order: determines which monitor gets the lowest workspace IDs.
	--- Monitors not listed are assigned priorities in the order Hyprland reports them.

	--- Per-monitor workspace count overrides (optional).
	--- Monitors not listed fall back to workspace_count.
	-- max_workspaces = { ["DP-2"] = 3 }, -- DP-2 gets only 3 workspaces, DP-1 is not overridden and gets 5.

	--- Keep the currently focused workspace when the config is reloaded (recommended).
	keep_focused = true,

	--- Show a Hyprland notification on init and remap.
	-- enable_notifications = false,

	--- Keep workspaces alive even when empty.
	---enable_persistent_workspaces = false,

	--- Wrap around when cycling past the first or last workspace.
	enable_wrapping = true,

	--- Switch all monitors simultaneously when changing workspaces (Gnome-style).
	-- link_monitors = false,
})

--- `get_amount_of_workspaces` is an easy helper function that simply returns the workspace_count you passed to the setup function.
local mainMod = "SUPER"
for i = 1, 10 do
	local n = tostring(i)
	if n == "10" then
		n = "0"
	end -- Optional if you configured 10 workspaces: bind workspace 10 to SUPER + 0
	-- Switch to the Nth workspace on the currently focused monitor.
	hl.bind(mainMod .. " + " .. n, smw.workspace(n))
	-- Move the active window to the Nth workspace on the currently focused monitor.
	hl.bind(mainMod .. " + SHIFT + " .. n, smw.move_to_workspace(n))
end

--- Cycle workspaces on the current monitor.
--- Accepts "next", "prev", "+N", or "-N" (e.g. "+2" skips two workspaces at once. why would you want to do that? idk but you can).
hl.bind(mainMod .. " + mouse_down", smw.cycle_workspaces("next"))
hl.bind(mainMod .. " + mouse_up", smw.cycle_workspaces("prev"))

--- Relative workspace switching using workspace().
--- "+N" / "-N" jump N workspaces forward/backward from the currently active one.
--- Wrapping behaviour follows the enable_wrapping config option.
hl.bind(mainMod .. " + PAGE_UP", smw.workspace("+1")) -- Next workspace (relative).
hl.bind(mainMod .. " + PAGE_DOWN", smw.workspace("-1")) -- Previous workspace (relative).

--- "empty" workspace: switch to the first empty workspace on the current monitor.
--- It can also be used as an argument with move_to_workspace(_silent) to move windows to the first empty workspace on the monitor.
--- Falls back to the last workspace in the monitor's range if all are occupied.
hl.bind(mainMod .. " + E", smw.workspace("empty"))
hl.bind(mainMod .. " + SHIFT + E", smw.move_to_workspace("empty"))

--- Move orphaned windows (not assigned to any mapped workspace) to the current workspace.
hl.bind(mainMod .. " + SHIFT + G", smw.grab_rogue_windows())
