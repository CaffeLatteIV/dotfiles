return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		-- pcall (Protected Call) catches the error so Neovim doesn't crash
		local status_ok, configs = pcall(require, "nvim-treesitter.configs")
		if not status_ok then
			return -- Silently exit so Lazy can finish booting and download the files!
		end

		configs.setup({
			-- Automatically install parsers for markdown and html
			ensure_installed = { "markdown", "markdown_inline", "html", "lua", "vim" },
			highlight = { enable = true },
		})
	end,
}
