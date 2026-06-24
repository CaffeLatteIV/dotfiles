return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local configs = require("nvim-treesitter.configs")

		configs.setup({
			-- Automatically install parsers for markdown and html
			ensure_installed = { "markdown", "markdown_inline", "html", "lua", "vim" },
			highlight = { enable = true },
		})
	end,
}
