vim.pack.add({ "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim.git" })

require("mason-tool-installer").setup({
	auto_update = true,
	ensure_installed = { "shellcheck", "shfmt", "tree-sitter-cli" },
	integrations = { ["mason-lspconfig"] = false },
})
