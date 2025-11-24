vim.keymap.set("n", "<leader>f", function()
	require("conform").format()
end, { desc = "Format buffer" })
