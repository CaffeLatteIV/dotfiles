vim.keymap.set("n", "<leader>f", function()
	require("conform").format()
end, { desc = "Format buffer" })

-- Navigating buffers
vim.keymap.set("n", "<leader>bb", "<C-^>", { desc = "Switch to alternate buffer" })
vim.keymap.set("n", "<leader>bn", ":bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", ":bprevious<cr>", { desc = "Previous buffer" })
