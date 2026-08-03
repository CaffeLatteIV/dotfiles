-- Press: <leader> then "f"
-- Action: Automatically formats the code in your current file using the 'conform' plugin.
vim.keymap.set("n", "<leader>f", function()
	require("conform").format()
end, { desc = "[F]ormat buffer" })

--
-- Navigating buffers
-- Press: <leader> then "b" then "b"
-- Action: Instantly toggles back and forth between your current file and your last-used file.
vim.keymap.set("n", "<leader>bb", "<C-^>", { desc = "Switch to alternate [b]uffer" })

-- Press: <leader> then "." (period)
-- Action: Cycles forward to the next open file (buffer) in your workspace.
vim.keymap.set("n", "<leader>.", ":bnext<cr>", { desc = "Next buffer" })

-- Press: <leader> then "," (comma)
-- Action: Cycles backward to the previous open file (buffer) in your workspace.
vim.keymap.set("n", "<leader>,", ":bprevious<cr>", { desc = "Previous buffer" })

-- Toggle visible whitespace characters
-- Press: <leader> then "l"
-- Action: Toggles the visibility of hidden characters (like spaces, tabs, and end-of-line markers).
vim.keymap.set("n", "<leader>l", ":set list!<cr>", { desc = "Toggle [l]istchars" })

-- Diagnostic keymaps
-- Press: <leader> then "q"
-- Action: Opens a panel at the bottom of the screen listing all code errors, warnings, and hints for the current file.
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- nvim tree
-- Press: <leader> + 1 (or Option + 1 on macOS)
-- Action: Opens or closes the NvimTree file explorer sidebar.
vim.keymap.set("n", "<leader>1", ":NvimTreeToggle<CR>", {})

-- Press: Ctrl + h, j, k, or l
-- Action: Easily jump between open split windows without typing Ctrl+w first.
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Press: <leader> then "s" then "v" (or "h")
-- Action: Split the current window vertically or horizontally.
vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })

-- Press: <leader> then "n" then "h"
-- Action: Clears the persistent highlights after you search for a word using '/'.
vim.keymap.set("n", "<leader>nh", ":nohlsearch<cr>", { desc = "Clear search highlights" })

-- Press: Ctrl + d  OR  Ctrl + u
-- Action: Scrolls down or up half a page, but keeps your cursor perfectly centered on the screen.
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down half page and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up half page and center" })

-- Press: Shift + J or Shift + K (while in Visual mode)
-- Action: Moves the selected block of code up or down.
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move text down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move text up" })

-- Press: <leader> then "f" then "f"
-- Action: Opens a floating window to fuzzy-search for files by name across your project.
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })

-- Press: <leader> then "f" then "g"
-- Action: Opens a floating window to search for a specific word or phrase inside all your files.
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Find text (live grep)" })
