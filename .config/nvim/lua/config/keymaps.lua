vim.keymap.set("n", "<leader>f", function()
	require("conform").format()
end, { desc = "Format buffer" })

-- Navigating buffers
vim.keymap.set("n", "<leader>bb", "<C-^>", { desc = "Switch to alternate buffer" })
vim.keymap.set("n", "<leader>.", ":bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>,", ":bprevious<cr>", { desc = "Previous buffer" })

-- Toggle visible whitespace characters
vim.keymap.set("n", "<leader>l", ":listchars!<cr>", { desc = "Toggle [l]istchars" })

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
