return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					javascript = { "prettier" },
					typescript = { "prettier" },
					javascriptreact = { "prettier" },
					typescriptreact = { "prettier" },
					svelte = { "prettier" },
					css = { "prettier" },
					html = { "prettier" },
					json = { "prettier" },
					yaml = { "prettier" },
					markdown = { "prettier" },
					graphql = { "prettier" },
					python = { "isort", "black" },
				},
				formatters = {
					black = {
						prepend_args = { "--line-length", "150" },
					},
					prettier = {
						prepend_args = function()
							return {
								"--no-semi",
								"--single-quote",
								"--no-bracket-spacing",
								"--print-width",
								"150",
								"--config-precedence",
								"prefer-file",
							}
						end,
					},
				},

				-- Optional: format on save
				format_on_save = function(bufnr)
					local disable_filetypes = { c = true, cpp = true }
					return {
						timeout_ms = 2000,
						lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
					}
				end,
			})
		end,
	},
}
