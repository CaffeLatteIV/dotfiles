---@module 'hl'
--monitor integrato
hl.monitor({
	output = "eDP-1",
	mode = "1920x1080",
	position = "0x0",
	scale = 1,
	bitdepth = 10,
})

--hl.workspace_rule({
--	workspace = 1,
--	monitor = "eDP-1",
--})
--monitor bunker scrauso
--hl.monitor({
--	output = "HDMI-A-1",
--	mode = "1600x900",
--	position = "1920x0",
--	scale = 1,
--	bitdepth = 10,
--})
--monitor 4k
hl.monitor({
	output = "HDMI-A-1",
	mode = "1920x1080",
	position = "1920x0",
	scale = 1,
	bitdepth = 10,
})
