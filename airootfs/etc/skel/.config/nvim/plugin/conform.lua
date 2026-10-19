vim.pack.add({ "https://github.com/stevearc/conform.nvim.git" })

require("conform").setup({
	format_on_save = { lsp_format = "fallback" },
	formatters_by_ft = { fish = { "fish_indent" } },
})
