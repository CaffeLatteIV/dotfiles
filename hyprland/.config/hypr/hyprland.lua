---@module 'hl'

require("keybinds")
require("monitors")
require("input")
require("plugins")
require("devices")
require("environment")

--- clipboard centrale e float
hl.config({
	debug = {
		disable_logs = true,
		gl_debugging = false,
	},
})
hl.window_rule({
	match = { class = "^(clipse)$" },
	float = true,
	center = true,
	size = { "(monitor_w*0.45)", "(monitor_h*0.55)" },
})
--general settings

hl.config({
	general = {
		gaps_in = 2,
		gaps_out = 4,
		border_size = 2,
		layout = "dwindle",
		--tokyonight theme
		resize_on_border = true,
		col = {
			active_border = "rgba(004687ff)",
		},
	},
})

hl.config({
	decoration = {
		rounding = 0,
		active_opacity = 0.9,
		inactive_opacity = 0.9,
		fullscreen_opacity = 1.0,
		blur = {
			enabled = true,
			size = 10,
			passes = 2,
			new_optimizations = true,
		},
		shadow = {
			enabled = false,
		},
	},
})

hl.config({
	animations = {
		enabled = true,
	},
})

-- dwindle touchpad

hl.config({
	dwindle = {
		preserve_split = true,
	},
})

hl.config({
	misc = {
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		vrr = 0,
		mouse_move_enables_dpms = true,
		key_press_enables_dpms = true,
		animate_manual_resizes = false,
		animate_mouse_windowdragging = false,
		enable_swallow = false,
		swallow_regex = "(foot|kitty|allacritty|Alacritty)",
		on_focus_under_fullscreen = 2,
		allow_session_lock_restore = true,
		session_lock_xray = true,
		initial_workspace_tracking = false,
		focus_on_activate = true,
	},

	binds = {
		scroll_event_delay = 0,
		hide_special_on_workspace_change = true,
	},
})

-- Autostart
hl.on("hyprland.start", function()
	-- 	hl.exec_cmd("~/.config/hypr/scripts/wallpaper_slideshow.sh") -- ora e' un proc su systemd
	hl.exec_cmd("hyprpm reload -n")
	hl.exec_cmd("clipse -listen")
end)
