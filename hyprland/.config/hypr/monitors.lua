---@module 'hl'
--monitor integrato
-- hl.monitor({
-- 	output = "eDP-1",
-- 	mode = "1920x1080",
-- 	position = "0x0",
-- 	scale = 1,
-- 	bitdepth = 10,
-- })

--monitor bunker scrauso
--hl.monitor({
--	output = "HDMI-A-1",
--	mode = "1600x900",
--	position = "1920x0",
--	scale = 1,
--	bitdepth = 10,
--})
--monitor 4k (bunker)
--hl.monitor({
--	output = "HDMI-A-1",
--	mode = "1920x1080",
--	position = "1920x0",
--	scale = 1,
--	bitdepth = 10,
--})
--
-- monitor pc fisso (primario)
hl.monitor({
	output = "DP-1",
	mode = "1920x1080@100.05",
	position = "0x0",
	scale = 1,
	bitdepth = 10,
})

-- monitor pc fisso (secondario)
hl.monitor({
	output = "DP-3",
	mode = "1920x1080@100.05",
	position = "-1920x0",
	scale = 1,
	bitdepth = 10,
})
