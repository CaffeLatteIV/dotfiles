return {
	"echasnovski/mini.trailspace",
	version = false,
	config = function()
		-- 1. Initialize the plugin
		require("mini.trailspace").setup()

		-- 2. Automatically trim on save
		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*",
			callback = function()
				MiniTrailspace.trim()
				MiniTrailspace.trim_last_lines()
			end,
		})
	end,
}
