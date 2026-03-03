return {
	"OXY2DEV/markview.nvim",
	lazy = false,

	-- Add your custom keymap here
	keys = {
		-- <leader>mv will trigger the toggle command
		{ "<leader>mv", "<cmd>Markview toggle<cr>", desc = "Toggle Markview rendering", mode = "n" },
	},

	opts = {
		preview = {
			modes = { "n", "i", "no", "c" },
			hybrid_modes = {},
		},
	},
}
