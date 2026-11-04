---@module 'hl'
-- Auto-detect connected outputs to apply the right monitor layout.
-- Reads /sys/class/drm (independent of Hyprland config), so switching between
-- laptop and desktop needs no manual config edit:
--   laptop  (eDP-1 present) : eDP-1 + HDMI-A-1 (4k, or 'bunker' 1600x900)
--   desktop (DP-1 present)  : DP-1 + DP-3
-- After plugging/unplugging a monitor, run `hyprctl reload`.

local function output_status(name)
    local p = io.popen("cat /sys/class/drm/card*-" .. name .. "/status 2>/dev/null")
    if not p then return nil end
    local s = p:read("*l") or ""
    p:close()
    return s:gsub("%s+", "")
end

local function preferred_mode(name)
    local p = io.popen("head -n 1 /sys/class/drm/card*-" .. name .. "/modes 2>/dev/null")
    if not p then return "" end
    local m = p:read("*l") or ""
    p:close()
    return m
end

if output_status("eDP-1") == "connected" then
    -- laptop: internal display + HDMI (4k normally, 'bunker' 1600x900 fallback)
    hl.monitor({ output = "eDP-1", mode = "1920x1080", position = "0x0", scale = 1.2, bitdepth = 10 })
    local mode = preferred_mode("HDMI-A-1")
    if mode:find("3840") then
        hl.monitor({ output = "HDMI-A-1", mode = "3840x2160@60.00", position = "1920x0", scale = 1.6, bitdepth = 10 })
    else
        hl.monitor({ output = "HDMI-A-1", mode = "1600x900", position = "1920x0", scale = 1, bitdepth = 10 })
    end
else
    -- desktop: DP-1 primary + DP-3 secondary
    hl.monitor({ output = "DP-1", mode = "1920x1080@100.05", position = "0x0", scale = 1, bitdepth = 10 })
    hl.monitor({ output = "DP-3", mode = "1920x1080@100.05", position = "-1920x0", scale = 1, bitdepth = 10 })
end
